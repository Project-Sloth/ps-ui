<script lang="ts">
    import { closeGame, currentActiveGameDetails, gameSettings } from "../stores/GameLauncherStore";
    import { createEventDispatcher, onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import { isDevMode } from "../stores/GeneralStores";

    const dispatch = createEventDispatcher();

    let gridSizesAcceptable = [
        {
            numberOfRowCol: 5,
            cubeSize: '4.2vw',
            gap: '1vw'
        },
        {
            numberOfRowCol: 6,
            cubeSize: '3.7vw',
            gap: '0.8vw'
        },
        {
            numberOfRowCol: 7,
            cubeSize: '2.9vw',
            gap: '1vw'
        },
        {
            numberOfRowCol: 8,
            cubeSize: '2.6vw',
            gap: '0.9vw'
        },
        {
            numberOfRowCol: 9,
            cubeSize: '2.4vw',
            gap: '0.75vw'
        },
        {
            numberOfRowCol: 10,
            cubeSize: '2.1vw',
            gap: '0.75vw'
        },
    ];

    let gameTimeRemaining = 0;

    let numberOfCorrectCubesToDisplay = $gameSettings.amountOfAnswers; // how many cubes to remember for game - increment number based on difficulty level
    let gameTime = $gameSettings.gameTime * 100;
    let numberOfWrongClicksAllowed = $gameSettings.maxAnswersIncorrect;

    let correctIndices = [], displayCorrectIndicesFor = $currentActiveGameDetails.displayInitialAnswersFor * 1000; // time in seconds
    let counter, gameStarted = false, gameEnded = false;
    let hackSuccess = false;
    let numberOfCubes = $currentActiveGameDetails.gridSize * $currentActiveGameDetails.gridSize;
    let allCubes = [];

    onMount(() => {
        //generate random indices from number of cubes
        while(correctIndices.length < numberOfCorrectCubesToDisplay){
            const r = Math.floor(Math.random() * numberOfCubes);
            if(correctIndices.indexOf(r) === -1) correctIndices.push(r);
        }

        //generating an array to maintain each cube data by index
        for(let i = 0; i < numberOfCubes; i++) {
            const cubeData = {
                cubeIndex: i,
                isCorrectAnswer: correctIndices.includes(i),
                isClicked: false
            };
            allCubes.push(cubeData);
            allCubes = allCubes;
        }

        let cubeWidthHeightValue = gridSizesAcceptable.filter((accept) => {
            return accept.numberOfRowCol === $currentActiveGameDetails.gridSize;
        })[0];

        setTimeout(() => {
            //assigning cube width and height
            allCubes.forEach((cube) => {
                const gameContainer = document.getElementById('memory-game-container');
                if(gameContainer) {
                    gameContainer.style.gap = cubeWidthHeightValue.gap;
                }
                
                const cubeDom = document.getElementById('each-cube-'+cube.cubeIndex);
                if(cubeDom) {
                    cubeDom.style.width = cubeWidthHeightValue.cubeSize;
                    cubeDom.style.height = cubeWidthHeightValue.cubeSize;
                    cubeDom.style.border = "2px solid var(--color-green)";
                }
            });
        }, 1500);
        
        //stop showing the correct cubes and start the guessing game
        setTimeout(() => {
            gameStarted = true;
            counter = setInterval(startTimer, 10);
        }, displayCorrectIndicesFor + 1500);

    });

    function startTimer() {
        if (gameTime <= 0)
        {
            gameEnded = true;
            hackSuccess = isSuccessful();
            clearInterval(counter);
            return;
         }
         gameTime--;
         gameTimeRemaining = gameTime/100;
    }

    function isSuccessful() {
        //all correct cubes clicked and wrong clicks are within threshold then success

        //all correct cubes clicked
        let allCorrectCubesClicked = false;
        allCubes.map((item) => {
            if(item.isCorrectAnswer && item.isClicked) {
                allCorrectCubesClicked = true;
            }
            if(item.isCorrectAnswer && !item.isClicked) {
                allCorrectCubesClicked = false;
            }
        });

        //wrong clicks within threshold
        const wrongClickedCubes = getWrongClicks();
        const wrongClicksWithinThreshold = wrongClickedCubes.length < numberOfWrongClicksAllowed;
        
        return allCorrectCubesClicked && wrongClicksWithinThreshold;
    }

    function getWrongClicks() {
        return allCubes.filter((item) => {
            return item.isClicked && !item.isCorrectAnswer;
        });
    }

    function guessAnswer(guessedCube) {
        if(!gameEnded) {
            const cubeIndexInArray = allCubes.findIndex((item) => item.cubeIndex === guessedCube.cubeIndex);

            let updatedCube = guessedCube;
            updatedCube.isClicked = true;

            allCubes[cubeIndexInArray] = updatedCube;

            const wrongClickedCubes = getWrongClicks();

            // if wrong clicks are done, end the game
            if(wrongClickedCubes.length >= numberOfWrongClicksAllowed) {
                clearInterval(counter);
                setTimeout(() => {
                    hackSuccess = false;
                    gameTimeRemaining = 0;
                    gameEnded = true;
                    return;
                }, 500);
            } 
            
            hackSuccess = isSuccessful();

            if(hackSuccess) {
                clearInterval(counter);
                gameTimeRemaining = 0;
                gameEnded = true;
            }
        }
    }

    $: {
        if(gameEnded) {
            if(!isDevMode) {
                fetchNui('minigame:callback', hackSuccess);
                dispatch('game-ended', { hackSuccess });
            }
            
            dispatch('closeUI', {hackSuccess})
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
<div class="memory-game-base">
    <div class="time-left">
        <i class="fa-solid fa-clock ps-text-lightgrey clock-icon"></i>
        <p class="{gameTimeRemaining !== 0 ? 'game-timer-var' : 'mr-1'}">{gameTimeRemaining} </p> time remaining
    </div>
    
    <div id="memory-game-container" class="memory-game-container" style="gap: 13px;">
        {#each allCubes as cube}
            <div 
                id={'each-cube-'+cube.cubeIndex} 
                on:click={() => guessAnswer(cube)}
                style="width: 0px; height: 0px; border: 0px;"
                class="each-cube {gameStarted ? 'cursor-pointer' : 'cursor-default'} {!gameStarted ? (cube.isCorrectAnswer ? 'ps-bg-green-cube' : '') : (cube.isClicked && cube.isCorrectAnswer ? 'ps-bg-green-cube' : (cube.isClicked && !cube.isCorrectAnswer ? 'ps-bg-wrong-cube' : ''))}">
            </div>
        {/each}
    </div>
</div>

<style>
    .memory-game-base {
        display: flex;
        flex-direction: column;

        height: 30vw;

        justify-content: center;
        align-items: center;
        color: var(--color-lightgrey);
    }

    .memory-game-base > .time-left {
        display: flex;
        flex-direction: row;
        justify-content: center;
        font-size: 0.85vw;
    }
    .memory-game-base > .time-left > .clock-icon {
       padding-top: 0.17vw;
       margin-right: 0.3vw;
    }
    .memory-game-base > .time-left > .game-timer-var {
        width: 2.5vw;
    }

    .memory-game-base > .memory-game-container {
        /* border: 0.1px solid red; */
        
        margin-top: 1vw;
        width: 30vw;
        height: 29vw;

        display: flex;
        flex-direction: row;
        justify-content: space-between;
        flex-wrap: wrap;
        /* gap: 1.5vw; */
    }
    .memory-game-base > .memory-game-container > .each-cube {
        /* width: 4.5vw;
        height: 4.5vw; */

        background-color: var(--cube-bg-darkgreen);
        border: 2px solid var(--color-green);
    }

    .ps-bg-green-cube {
		background-color: var(--color-green) !important;
	}
    .ps-bg-wrong-cube {
		background-color: var(--color-red) !important;
	}
</style>