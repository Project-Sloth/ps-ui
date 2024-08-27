<script lang="ts">
    import { closeGame, currentActiveGameDetails, gameSettings } from "../stores/GameLauncherStore";
    import { createEventDispatcher, onMount } from "svelte";
    import fetchNui from "../../utils/fetch";
    import { getRandomArbitrary, isDevMode } from "../stores/GeneralStores";

    const dispatch = createEventDispatcher();

    const randomSetChar = () => {
        let str='?';
        switch($currentActiveGameDetails.sets) {
            case 'numeric':
                str="0123456789";
                break;
            case 'alphabet':
                str="ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                break;
            case 'alphanumeric':
                str="ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
                break;
            case 'greek':
                str="ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ";
                break;
            case 'braille':
                str="⡀⡁⡂⡃⡄⡅⡆⡇⡈⡉⡊⡋⡌⡍⡎⡏⡐⡑⡒⡓⡔⡕⡖⡗⡘⡙⡚⡛⡜⡝⡞⡟⡠⡡⡢⡣⡤⡥⡦⡧⡨⡩⡪⡫⡬⡭⡮⡯⡰⡱⡲⡳⡴⡵⡶⡷⡸⡹⡺⡻⡼⡽⡾⡿"+
                    "⢀⢁⢂⢃⢄⢅⢆⢇⢈⢉⢊⢋⢌⢍⢎⢏⢐⢑⢒⢓⢔⢕⢖⢗⢘⢙⢚⢛⢜⢝⢞⢟⢠⢡⢢⢣⢤⢥⢦⢧⢨⢩⢪⢫⢬⢭⢮⢯⢰⢱⢲⢳⢴⢵⢶⢷⢸⢹⢺⢻⢼⢽⢾⢿"+
                    "⣀⣁⣂⣃⣄⣅⣆⣇⣈⣉⣊⣋⣌⣍⣎⣏⣐⣑⣒⣓⣔⣕⣖⣗⣘⣙⣚⣛⣜⣝⣞⣟⣠⣡⣢⣣⣤⣥⣦⣧⣨⣩⣪⣫⣬⣭⣮⣯⣰⣱⣲⣳⣴⣵⣶⣷⣸⣹⣺⣻⣼⣽⣾⣿";
                break;
            case 'runes':
                str="ᚠᚥᚧᚨᚩᚬᚭᚻᛐᛑᛒᛓᛔᛕᛖᛗᛘᛙᛚᛛᛜᛝᛞᛟᛤ";
                break;
        }
        return str.charAt(getRandomArbitrary(0, str.length));
    }

    let gameTimeRemaining = 0;

    let amountOfAnswers = $gameSettings.amountOfAnswers; // how many numbers for game
    let gameTime = $gameSettings.gameTime * 100; // seconds

    let correctIndices = [], correctAnswers = [];
    let changeBoardAfter = $currentActiveGameDetails.changeBoardAfter * 100; //3 seconds 
    let originalChangeBoardAfter = changeBoardAfter;
    let counter, gameStarted = false, gameEnded = false;
    let hackSuccess = false;
    let numberOfCubes = 80, allCubes = [];
    let totalNumberOfColumns = 10;

    let cursorIndices = [], cursorStartIndex = 43;

    onMount(() => {
        //generating an array to maintain each cube data by index
        for(let i = 0; i < numberOfCubes; i++) {
            const cubeData = {
                cubeIndex: i,
                cubeValue: randomSetChar() + randomSetChar(),
            };
            allCubes.push(cubeData);
            allCubes = allCubes;
        }

        //generate correct answer values - column number - has to be Number of cols - 4 to have straight 4 answers
        const columnNumber = Math.floor(Math.random() * 5);
        //generate correct answer values - row number
        const rowNumber = Math.floor(Math.random() * 7);

        const startIndex = rowNumber * totalNumberOfColumns + columnNumber;
        correctAnswers = [];
        for(let i = 0; i < amountOfAnswers; i++) {
            correctAnswers.push(allCubes[i + startIndex]);
            correctIndices.push(i+startIndex);
        }

        getCursorIndices();

        //start game
        setTimeout(() => {
            gameStarted = true;
            counter = setInterval(startTimer, 10);
        }, 1000);

    });

    function getCursorIndices() {
        cursorIndices = [cursorStartIndex];
        for(let i=1; i<4; i++){
            if( cursorStartIndex+i >= 80 ){
                cursorIndices.push( (cursorStartIndex+i) - 80 );
            }else{
                cursorIndices.push( cursorStartIndex+i );
            }
        }
        // return group;
    }

    function endTheGame() {
        clearInterval(counter);
        gameEnded = true;

        setTimeout(() => {
            if(!isDevMode) {
                fetchNui('minigame:callback', hackSuccess);
                dispatch('game-ended', { hackSuccess });
            }
            dispatch('minigame:callback', hackSuccess);
        }, 500);
    }

    function startTimer() {
        if (gameTime <= 0)
        {
            hackSuccess = false;
            endTheGame();
            return;
        } else if (changeBoardAfter <= 0) {
            scrambleBoard();
        }

         gameTime--;
         changeBoardAfter--;
         
         gameTimeRemaining = gameTime/100;
    }

    function scrambleBoard() {
        changeBoardAfter = originalChangeBoardAfter;

         //generating an array to maintain each cube data by index
         let newCubeData = [];
         for(let i = 0; i < numberOfCubes; i++) {
            let cubeValue;

            if(i === numberOfCubes - 1) {
                cubeValue = allCubes[0].cubeValue;
            } else {
                cubeValue = allCubes[i+1].cubeValue;
            }
            const cubeData = {
                cubeIndex: i,
                cubeValue: cubeValue,
            };
            newCubeData.push(cubeData);
            newCubeData = newCubeData;
        }
        getCursorIndices();

        allCubes = newCubeData;
    }

    function checkAnswer() {
        let selectedValues = cursorIndices.map((currentCursorIndex) => {
            return allCubes[currentCursorIndex];
        });
        
        const selectedValuesData = selectedValues.map((item) => {
            return item.cubeValue;
        });

        const correctAnswerValues = correctAnswers.map((item) => {
            return item.cubeValue;
        });

        if(JSON.stringify(selectedValuesData) === JSON.stringify(correctAnswerValues)) {
            hackSuccess = true;
        } else {
            hackSuccess = false;
        }

        endTheGame();
    }

    function handleKeyEvent(event) {
        let key_pressed = event.key;
        let valid_keys = ['a','w','s','d', 'A','W','S','D' ,'ArrowUp','ArrowDown','ArrowRight','ArrowLeft','Enter', 'Escape'];

        if(gameStarted && valid_keys.includes(key_pressed) && !gameEnded) {
            switch(key_pressed){
                case 'w':
                case 'ArrowUp':
                    cursorStartIndex -= 10;
                    if(cursorStartIndex < 0) {
                        cursorStartIndex += 80;
                    }
                    break;
                case 's':
                case 'ArrowDown':
                    cursorStartIndex += 10;
                    cursorStartIndex %= 80;
                    break;
                case 'a':
                case 'ArrowLeft':
                    cursorStartIndex--;
                    if(cursorStartIndex < 0) {
                        cursorStartIndex = 79;
                    }
                    break;
                case 'd':
                case 'ArrowRight':
                    cursorStartIndex++;
                    cursorStartIndex %= 80;
                    break;
                case 'Enter':
                    clearInterval(counter);
                    checkAnswer();
                    return;
                case 'Escape':
                    closeGame(false);
                    return;
            }
        }
    }

    $: {
        if(cursorStartIndex) {
            getCursorIndices();
        }
    }
</script>

<svelte:window on:keydown|preventDefault={handleKeyEvent} />
<div class="scrambler-game-base">
    <div class="game-info-container">
        <div class="scrambler-find-data">
            <p>Match the numbers underneath.</p>
            <div class="original-data-wrapper">
                {#each correctAnswers as value}
                    <p class="original-digits">{value.cubeValue}</p>
                {/each}
            </div>
        </div>
        <div class="time-left">
            <i class="fa-solid fa-clock ps-text-lightgrey clock-icon"></i>
            <p class="{gameTimeRemaining !== 0 ? 'game-timer-var' : 'mr-1'}">{gameTimeRemaining} </p> time remaining
        </div>
    </div>
    
    <div id="scrambler-game-container" class="scrambler-game-container">
        {#each allCubes as cube}
            <div id={'each-cube-'+cube.cubeIndex} class="each-cube">
                <p class="{!gameEnded && cursorIndices.includes(cube.cubeIndex) ? 'ps-text-red' : ''}">{cube.cubeValue}</p>
            </div>
        {/each}
    </div>
</div>

<style>
    .scrambler-game-base {
        display: flex;
        flex-direction: column;
        height: 28vw;

        justify-content: center;
        align-items: center;
        color: var(--color-lightgrey);
    }

    .scrambler-game-base > .game-info-container {
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .scrambler-game-base > .game-info-container > .scrambler-find-data {
        display: flex;
        flex-direction: column;
    }

    .scrambler-game-base > .game-info-container > .scrambler-find-data > .original-data-wrapper {
        width: max-content;
        border: 2px solid var(--color-green);
        border-radius: 0.2vw;
        background-color: var(--cube-bg-darkgreen);
        color: var(--color-green);

        margin: 0.5vw auto;

        display: flex;
        flex-direction: row;
        justify-content: space-evenly;
    }
    .scrambler-game-base > .game-info-container > .scrambler-find-data > .original-data-wrapper > .original-digits {
        font-size: 1vw;
        padding: 0.3vw 0.5vw;
    }

    .scrambler-game-base > .game-info-container > .time-left {
        display: flex;
        flex-direction: row;
        justify-content: center;
        font-size: 0.85vw;
    }
    .scrambler-game-base > .game-info-container > .time-left > .clock-icon {
       padding-top: 0.17vw;
       margin-right: 0.3vw;
    }
    .scrambler-game-base > .game-info-container > .time-left > .game-timer-var {
        width: 2.5vw;
    }

    .scrambler-game-base > .scrambler-game-container {
        /* border: 0.1px solid red; */
        
        margin-top: 1vw;
        width: 30vw;
        height: 24vw;

        display: flex;
        flex-direction: row;
        justify-content: space-between;
        flex-wrap: wrap;
        gap: 0.5vw;
    }
    .scrambler-game-base > .scrambler-game-container > .each-cube {
        width: 2.5vw;
        height: 2.5vw;

        font-size: 1.75vw;
        text-align: center;
        margin: auto;
    }
</style>