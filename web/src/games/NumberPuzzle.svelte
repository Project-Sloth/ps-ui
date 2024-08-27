<script lang="ts">
    import { gameSettings, currentActiveGameDetails, closeGame } from "../stores/GameLauncherStore";
    import { createEventDispatcher, onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import mojs from '@mojs/core';
    import { convertVwToPx, getRandomArbitrary, isDevMode } from "../stores/GeneralStores";

    const dispatch = createEventDispatcher();

    let gameTimeRemaining = 0;

    let blocksInput = $gameSettings.amountOfAnswers; // how many cubes to remember for game - increment number based on difficulty level
    let gameTime = $gameSettings.gameTime * 100;
    let numberOfWrongClicksAllowed = $gameSettings.maxAnswersIncorrect;
    let displayNumbersOnCubesFor = $currentActiveGameDetails.timeForNumberDisplay * 100;

    let counter, gameStarted = false, gameEnded = false;
    let allCubes = [];
    let order = 0, wrongClicks = 0;
    let cubeBgColors = ['var(--color-green)', 'var(--color-palegreen)', 'var(--color-blue)'];

    // let topLowerBound = 290, topHigherBound = 660; px
    // let leftLowerBound = 77, leftHigherBound = 459;
    let topLowerBound = 18, topHigherBound = 40; //vw
    let leftLowerBound = 2, leftHigherBound = 28;

    onMount(() => {
        //generate shuffled cubes indices
        let cubeIndicesList = [];
        while(cubeIndicesList.length < blocksInput){
            const r = Math.floor(Math.random() * blocksInput);
            if(cubeIndicesList.indexOf(r) === -1) cubeIndicesList.push(r);
        }

        //generating an array to maintain each cube data by index
        for(let i = 0; i < cubeIndicesList.length; i++) {
            //height between 290 and 660 px
            //horizontal between 77 and 459 px
            const cubeData = {
                cubeIndex: cubeIndicesList[i],
                cubeValue: cubeIndicesList[i],
                bgColor: cubeBgColors[Math.floor(Math.random() * cubeBgColors.length)],
                top: getRandomArbitrary(topLowerBound, topHigherBound),
                left: getRandomArbitrary(leftLowerBound, leftHigherBound)
            };
            allCubes.push(cubeData);
            allCubes = allCubes;
        }

        //stop showing the correct cubes and start the guessing game
        setTimeout(() => {
            gameStarted = true;

            let eachCube = document.querySelectorAll('.each-cube');
            eachCube.forEach(el => { newPos(el) });

            counter = setInterval(startTimer, 10);
        }, 1000);
    });

    function newPos(element) {
        let top = element.offsetTop;
        let left = element.offsetLeft;

        let new_top_vw = getRandomArbitrary(topLowerBound,topHigherBound);
        let new_left_vw = getRandomArbitrary(leftLowerBound,leftHigherBound);

        let new_top = convertVwToPx(new_top_vw);
        let new_left = convertVwToPx(new_left_vw);

        let diff_top = new_top - top;
        let diff_left = new_left - left;
        
        let duration = getRandomArbitrary(10,40)*100;
        
        new mojs.Html({
            el: '#'+element.id,
            x: {
                0:diff_left,
                duration: duration,
                easing: 'linear.none'
            },
            y: {
                0:diff_top,
                duration: duration,
                easing: 'linear.none'
            },
            duration: duration+50,
            onComplete() {
                if(element.offsetTop === 0 && element.offsetLeft === 0) {
                    this.pause();
                    return;
                }
                const bgColor = element.style.backgroundColor;
                element.style = 'background-color: '+bgColor+'; top: '+new_top_vw+'vw; left: '+new_left_vw+'vw; transform: none;';
                newPos(element);
            },
            onUpdate() {
                if(gameStarted === false) this.pause();
            }
        }).play();
    }

    function startTimer() {
        if (gameTime <= 0)
        {
            endGame(false);
            return;
        } 
        displayNumbersOnCubesFor--;
        gameTime--;        
        gameTimeRemaining = gameTime/100;
    }

    function handleClick(clickedCube) {
        if(gameStarted && !gameEnded && displayNumbersOnCubesFor <= 0) {
            //correct click
            if(order === clickedCube.cubeIndex) {
                let clickedCubeDom = document.getElementById('each-cube-'+clickedCube.cubeIndex);
                clickedCubeDom.style.backgroundColor = 'var(--color-darkgrey)';
                order = order + 1;
            } else {
                wrongClicks = wrongClicks + 1;
            }
            checkGameStatus();
        }
       
    }

    function checkGameStatus() {
        if(order === allCubes.length - 1 && wrongClicks < numberOfWrongClicksAllowed) {
            endGame(true);
        } else if(order < allCubes.length - 1 && wrongClicks >= numberOfWrongClicksAllowed) {
            endGame(false);
        }
    }

    function endGame(isSuccess) {
        if(!gameEnded) {
            gameEnded = true;
            clearInterval(counter);
            
            setTimeout(() => {
                if(!isDevMode) {
                    fetchNui('minigame:callback', isSuccess);
                    dispatch('game-ended', { hackSuccess: isSuccess });
                }
                dispatch('minigame:callback', {hackSuccess: isSuccess});
            }, 1000);
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
<div class="var-game-base">
    <div class="time-left">
        <i class="fa-solid fa-clock ps-text-lightgrey clock-icon"></i>
        <p class="{gameTimeRemaining !== 0 ? 'game-timer-var' : 'mr-1'}">{gameTimeRemaining} </p> time remaining
    </div>
    
    <div id="var-game-container" class="var-game-container">
        {#each allCubes as cube}
            <div 
                id={'each-cube-'+cube.cubeIndex} 
                class="each-cube"
                style="background-color:{cube.bgColor}; top: {cube.top}vw; left: {cube.left}vw;"
                on:click={() => handleClick(cube)}
            >
                {#if displayNumbersOnCubesFor > 0}
                    <p>{cube.cubeValue + 1}</p>
                {/if}
            </div>
        {/each}
    </div>
</div>

<style>
    .var-game-base {
        display: flex;
        flex-direction: column;

        height: 28vw;

        justify-content: center;
        align-items: center;
        color: var(--color-lightgrey);
    }

    .var-game-base > .time-left {
        display: flex;
        flex-direction: row;
        justify-content: center;
        font-size: 0.85vw;
    }
    .var-game-base > .time-left > .clock-icon {
       padding-top: 0.17vw;
       margin-right: 0.3vw;
    }
    .var-game-base > .time-left > .game-timer-var {
        width: 2.5vw;
    }

    .var-game-base > .var-game-container {
        border: 2px solid var(--color-green);
        background-color: var(--cube-bg-darkgreen);
        
        margin-top: 1vw;
        width: 30vw;
        height: 28vw;
    }
    .var-game-base > .var-game-container > .each-cube {
        width: 3vw;
        height: 3vw;

        border: 2px solid var(--color-lightgrey);
        position: absolute;

        text-align: center;
        cursor: default;
    }
    .var-game-base > .var-game-container > .each-cube > p {
        font-size: 1.5vw;
        font-weight: bold;
        margin-top: 0.2vw;
        color: var(--color-black);
    }
</style>