<script lang="ts">
    import { currentActiveGameDetails, currentGameActive } from "../stores/GameLauncherStore";
    import Skull from "../assets/svgs/Skull.svelte";
    import { GamesEnum } from "../enums/GamesEnum";
    import NewMemoryGame from "./MemoryGame.svelte";
    import SuccessFailureScreen from "./SuccessFailureScreen.svelte";
    import NewScrambler from "./Scrambler.svelte";
    import NewNumberMaze from "./NumberMaze.svelte";
    import NewNumberPuzzle from "./NumberPuzzle.svelte";

    const skullColor: string = 'var(--color-green)';

    let showResultScreen = false, hackSuccess = false;
</script>

{#if !showResultScreen}
    <div class="games-container">
        <div class="game-wrapper ps-bg-darkblue">
            <div class="skull-logo">
                <Skull color={skullColor} />
            </div>

            <div class="game-heading">
                <p class="ps-font-arcade">
                    {$currentActiveGameDetails?.gameName}
                </p>
            </div>

            <div class="game-description">
                <p>{$currentActiveGameDetails?.gameDescription}</p>
            </div>

            <div class="main-game-body">
                {#if $currentGameActive === GamesEnum.Memory}
                    <NewMemoryGame on:game-ended={(event) => {showResultScreen = true; hackSuccess = event.detail.hackSuccess; }} />
                {:else if $currentGameActive === GamesEnum.Scrambler}
                    <NewScrambler on:game-ended={(event) => {showResultScreen = true; hackSuccess = event.detail.hackSuccess; }} />
                {:else if $currentGameActive === GamesEnum.NumberMaze}
                    <NewNumberMaze on:game-ended={(event) => {showResultScreen = true; hackSuccess = event.detail.hackSuccess; }} />
                {:else if $currentGameActive === GamesEnum.NumberPuzzle}
                    <NewNumberPuzzle on:game-ended={(event) => {showResultScreen = true; hackSuccess = event.detail.hackSuccess; }} />
                {/if}
            </div>
        </div>
    </div>
{:else}
    <SuccessFailureScreen isSuccess={hackSuccess} />
{/if}

<style>
.games-container {
    position: absolute;
    left: 50%;  
    top: 50%;
    -webkit-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);  
    
    border-radius: 0.2vw;
}

.games-container > .game-wrapper {
    width: 33vw;
    height: 45vw;
    border-radius: 0.3vw;
    overflow: hidden;

    display: flex;
    flex-direction: column;
}

.games-container > .game-wrapper > .skull-logo {
    margin: 0 auto;
    padding-top: 1vw;
    width: 5vw;
}

.games-container > .game-wrapper > .game-heading {
    font-size: 1.1vw;
    letter-spacing: 0.4vw;
    color: var(--color-lightgrey);

    margin: 0.25vw auto;

    width: 19vw;
    text-align: center;
}

.games-container > .game-wrapper > .game-description {
    font-size: 0.7vw;
    font-weight: normal;
    color: var(--color-lightgrey);
    text-align: center;

    width: 33vw;
    margin: 1vw auto;
}

.games-container > .game-wrapper > .main-game-body {
    margin: 0.75vw auto 2vw auto;
    width: 31vw;
    /* border: 0.1px solid yellow; */
    height: 30vw;
}
</style>