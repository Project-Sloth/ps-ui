<script lang="ts">
    import { closeGame, gameSettings } from "../stores/GameLauncherStore";
    import { createEventDispatcher, onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import { getRandomArbitrary, isDevMode } from "../stores/GeneralStores";

    const dispatch = createEventDispatcher();

    let gameTimeRemaining = 0;

    let gameTime = $gameSettings.gameTime * 100;
    let numberOfWrongClicksAllowed = $gameSettings.maxAnswersIncorrect;

    let counter, gameStarted = false, gameEnded = false;
    let numberOfCubes = 49, allCubes = [];
    let blinkingIndex, correctRoute = [], goodPositions = [], stopBlinking = false;
    let lastPos = 0, wrongAnswerCount = 0;
    let displayCubeNumbers = false;

    onMount(() => {
        //get starting blinking index
        blinkingIndex = getRandomArbitrary(1,4); // 4 => highest index,  => lowest index for blink

        //generate the correct route
        correctRoute = generateBestRoute(blinkingIndex);
        
        goodPositions = Object.keys(correctRoute);

        //generating an array to maintain each cube data by index
        for(let i = 0; i < numberOfCubes; i++) {
            const cubeValue = [blinkingIndex, blinkingIndex * 7].includes(i) ? getRandomArbitrary(1,4) : getRandomArbitrary(1,5);
            
            const cubeData = {
                cubeIndex: i,
                cubeValue: goodPositions.includes(i.toLocaleString()) ? correctRoute[i] : cubeValue,
                classList: ''
            };
            allCubes.push(cubeData);
            allCubes = allCubes;
        }

        //stop showing the correct cubes and start the guessing game
        setTimeout(() => {
            gameStarted = true;
            counter = setInterval(startTimer, 10);
        }, 1000);

    });

    function maxVertical(pos) {
        return Math.floor((48-pos)/7);
    }

    function maxHorizontal(pos) {
        let max = (pos+1) % 7;
        if(max > 0) return 7-max;
            else return 0;
    }

    function generateNextPosition(pos) {
        let maxV = maxVertical(pos);
        let maxH = maxHorizontal(pos);
        if(maxV === 0 ){
            let new_pos = getRandomArbitrary(getRandomArbitrary(1,maxH), maxH);
            return [new_pos, pos+new_pos];
        }
        if(maxH === 0 ){
            let new_pos = getRandomArbitrary(getRandomArbitrary(1,maxV), maxV);
            return [new_pos, pos+(new_pos*7)];
        }
        if(Math.floor(Math.random() * 1000 + 1) % 2 === 0 ){
            let new_pos = getRandomArbitrary(getRandomArbitrary(1,maxH), maxH);
            return [new_pos, pos+new_pos];
        } else {
            let new_pos = getRandomArbitrary(getRandomArbitrary(1,maxV), maxV);
            return [new_pos, pos+(new_pos*7)];
        }
    }

    function generateBestRoute(start_pos) {
        let route = [];
        if(getRandomArbitrary(1,1000) % 2 === 0 ){
            start_pos *= 7;
        }
        while(start_pos < 48){
            let new_pos = generateNextPosition(start_pos);
            route[start_pos] = new_pos[0];
            start_pos = new_pos[1];
        }
        
        return route;
    }

    function startTimer() {
        if (gameTime <= 0)
        {
            wrongAnswerCount = numberOfWrongClicksAllowed;
            checkMazeAnswer();
            return;
         } 
         gameTime--;
         gameTimeRemaining = gameTime/100;
    }

    function updateAllCubesArrayWithClassListOfClickedCube(isGood, clickedCube) {
        const additionClassString = isGood ? ' ps-bg-green-cube' : ' ps-bg-wrong-cube';
        const newClassList = clickedCube.classList + additionClassString;
        clickedCube.classList = newClassList;

        //replace the clicked cube data in allCubes array
        allCubes[clickedCube.cubeIndex] = clickedCube;
        allCubes = allCubes;
    }

    
    function handleCubeClick(clickedCube) {
        if(!gameEnded && clickedCube.cubeIndex !== 0) {
            let posClicked = clickedCube.cubeIndex;
            //game just started and user made first click
            if(lastPos === 0) {
                //stop the blinking and hide numbers on cubes
                stopBlinking = true;
                if([blinkingIndex, blinkingIndex * 7].includes(posClicked)) {
                    lastPos = posClicked;

                    //display good cube click and update allCubes array
                    updateAllCubesArrayWithClassListOfClickedCube(true, clickedCube);
                } else {
                    wrongAnswerCount++;
                    //display bad cube click and update allCubes array
                    updateAllCubesArrayWithClassListOfClickedCube(false, clickedCube);
                }
            } else {
                let posJumps = allCubes[lastPos].cubeValue;
                let maxV = maxVertical(lastPos);
                let maxH = maxHorizontal(lastPos);

                if(posJumps <= maxH && posClicked === lastPos + posJumps) {
                    lastPos = posClicked;
                    //display good cube click and update allCubes array
                    updateAllCubesArrayWithClassListOfClickedCube(true, clickedCube);
                } else if (posJumps <= maxV && posClicked === lastPos + (posJumps * 7)) {
                    lastPos = posClicked;
                    //display good cube click and update allCubes array
                    updateAllCubesArrayWithClassListOfClickedCube(true, clickedCube);
                } else {
                    wrongAnswerCount++;
                    //display bad cube click and update allCubes array
                    updateAllCubesArrayWithClassListOfClickedCube(false, clickedCube);
                }
            }
        }

        checkMazeAnswer();
    }

    function checkMazeAnswer() {
        // check if wrong answers exceeded / game ended - both with same condition
        // if yes, end the game, clear counter and display correct answers and then stop game
        // else, end the game within few seconds
        if(wrongAnswerCount === numberOfWrongClicksAllowed) {
            clearInterval(counter);
            
            displayCubeNumbers = true;

            allCubes = allCubes.map((cube) => {
                cube.classList = goodPositions.includes(cube.cubeIndex.toLocaleString()) ? 'ps-bg-green-cube' : '';
                return cube;
            });
            allCubes = allCubes;

            setTimeout(() => {
                gameEnded = true;
                if(!isDevMode) {
                    fetchNui('minigame:callback', false);
                    dispatch('game-ended', { hackSuccess: false });
                }
                dispatch('closeUI', {hackSuccess: false});
            }, 3000);

            return;
        } else if(lastPos === 48){
            clearInterval(counter);
            
            displayCubeNumbers = true;

            setTimeout(() => {
                gameEnded = true;
                if(!isDevMode) {
                    fetchNui('minigame:callback', true);
                    dispatch('game-ended', { hackSuccess: true });
                }
                dispatch('closeUI', {hackSuccess: true});
            }, 3000);
        }
    }

    function handleKeyEvent(event) {
        let key_pressed = event.key;
        let valid_keys = ['Escape'];

        if(gameStarted && valid_keys.includes(key_pressed) && !gameEnded) {
            switch(key_pressed){
                case 'Escape':
                    closeGame(false);
                    return;
            }
        }
    }
</script>

<svelte:window on:keydown|preventDefault={handleKeyEvent} />
<div class="maze-game-base">
    <div class="time-left">
        <i class="fa-solid fa-clock ps-text-lightgrey clock-icon"></i>
        <p class="{gameTimeRemaining !== 0 ? 'game-timer-var' : 'mr-1'}">{gameTimeRemaining} </p> time remaining
    </div>
    <div id="maze-game-container" class="maze-game-container">
        {#each allCubes as cube}
            <div 
                id={'each-cube-'+cube.cubeIndex} on:click={() => handleCubeClick(cube)}
                class="each-cube {cube.classList}
                    {[0, numberOfCubes - 1].includes(cube.cubeIndex) ? 'start-dest-cube' : ''} 
                    {!stopBlinking && [blinkingIndex, blinkingIndex * 7].includes(cube.cubeIndex) ? 'blinking-cube' : ''}
                "
            >
                {#if cube.cubeIndex === 0}
                    <i class="fa-solid fa-ethernet"></i>
                {:else if cube.cubeIndex === numberOfCubes - 1}
                    <i class="fa-solid fa-network-wired"></i>
                {:else}
                    {#if !stopBlinking || displayCubeNumbers}
                        <p>{ cube.cubeValue }</p>
                    {/if}
                {/if}
            </div>
        {/each}
    </div>
</div>

<style>
    .maze-game-base {
        display: flex;
        flex-direction: column;

        height: 28vw;

        justify-content: center;
        align-items: center;
        color: var(--color-lightgrey);
    }

    .maze-game-base > .time-left {
        display: flex;
        flex-direction: row;
        justify-content: center;
        font-size: 0.85vw;
    }
    .maze-game-base > .time-left > .clock-icon {
       padding-top: 0.17vw;
       margin-right: 0.3vw;
    }
    .maze-game-base > .time-left > .game-timer-var {
        width: 2.5vw;
    }

    .maze-game-base > .maze-game-container {
        /* border: 0.1px solid red; */
        
        margin-top: 0.5vw;
        width: 30vw;
        height: 29vw;

        display: flex;
        flex-direction: row;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 0.9vw;
    }
    .maze-game-base > .maze-game-container > .start-dest-cube {
        background-color: var(--color-green) !important;
        color: var(--color-darkblue);

        font-size: 1.65vw;
        text-align: center;
    }
    .maze-game-base > .maze-game-container > .start-dest-cube > i {
        vertical-align: middle;
    }
    .maze-game-base > .maze-game-container > .each-cube {
        width: 3vw;
        height: 3vw;

        background-color: var(--cube-bg-darkgreen);
        border: 2px solid var(--color-green);
        text-align: center;

        cursor: default;
    }

    .maze-game-base > .maze-game-container > .each-cube > p {
        font-size: 1.5vw;
        font-weight: bold;
        margin-top: 0.2vw
    }

    .blinking-cube {
        animation: blink 1s linear infinite; 
    }

    @keyframes blink { 
        0%, 
        100% { 
            background-color: var(--color-green); 
            /* background-color: var(--cube-bg-darkgreen);  */
        } 

        50% { 
            background-color: var(--cube-bg-darkgreen); 
        } 
    } 

    .ps-bg-green-cube {
		background-color: var(--color-green) !important;
	}
    .ps-bg-wrong-cube {
		background-color: var(--color-red) !important;
	}

    
</style>