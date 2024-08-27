<script lang="ts">
    import { onMount } from "svelte";
    import Skull from "../assets/svgs/Skull.svelte";
    import { closeUi } from "../stores/GameLauncherStore";

    export let isSuccess = false;
    const skullColor: string = 'var(--color-green)';

    onMount(() => {
        setTimeout(() => {
            closeUi();
        }, 2000);
    })
</script>

<div class="result-container">
    <div class="result-wrapper ps-bg-darkblue">
        <div class="skull-logo">
            <Skull color={skullColor} />
        </div>
        {#if isSuccess}
            <h1 class="text-white text-3xl uppercase">
                Access granted
            </h1>
        {:else}
            <h1 class="text-white text-3xl uppercase">
                Access denied
            </h1>
        {/if}
    </div>
    
</div>

<style>
.result-container {
    position: absolute;
    left: 50%;  
    top: 50%;
    -webkit-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);  
    
    border-radius: 0.2vw;
}

.result-container > .result-wrapper {
    width: 30vw;
    height: 15vw;
    border-radius: 0.3vw;
    overflow: hidden;

    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}

.result-container > .result-wrapper > .skull-logo {
    margin: 0 auto 1vw auto;
    width: 6vw;
}
</style>