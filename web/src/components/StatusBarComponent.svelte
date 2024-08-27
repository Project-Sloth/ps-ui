<script lang="ts">
    import { hideStatusBar, hideStatusBarStore, statusBarStore } from "../stores/StatusBarStores";
    import { onMount } from "svelte";
    import Icon from "./Icon.svelte";
    import type { IStatusBarItem } from "src/interfaces/IStatusBar";
    import { isDevMode, showComponent, showUi } from "../stores/GeneralStores";

    let statusData:any = $statusBarStore;
    let statusDataItems:[IStatusBarItem] = statusData.items;

    statusBarStore.subscribe((value) => {
        statusData = value;
        statusDataItems = statusData.items;
    });

    let hideStatusBarValue = false;
    hideStatusBarStore.subscribe(value => {
        hideStatusBarValue = value;
    });

    onMount(() => {
        if(isDevMode) {
            setTimeout(() => {
                hideStatusBar();
            }, 10000);
        }
    });

    function closeStatusBar() {
        const statusWrapperDom = document.getElementById('status-bar-wrapper');
        if(statusWrapperDom) {
            statusWrapperDom.style.animation = '2s hide-statusbar';

            let keyFrames = document.createElement('style');
            
            keyFrames.innerHTML =  `
                @keyframes hide-statusbar {
                    from {
                        opacity: 1;
                    }
                    to {
                        opacity: 0;
                    }
                }

                .status-bar-wrapper {
                    -moz-animation: 2s hide-statusbar;
                    -webkit-animation: 2s hide-statusbar;
                    animation: 2s hide-statusbar;
                }
            `;

            statusWrapperDom.appendChild(keyFrames);

            setTimeout(() => {
                showUi.set(false);
                showComponent.set(null);
                
                statusBarStore.set({
                    title: '',
                    description: '',
                    items: [],
                    icon: '',
                });
                hideStatusBarStore.set(false);
            }, 500);
        }
    }

    $: {
        if(hideStatusBarValue) {
            // if(hideStatusBarValue || !hideStatusBarValue)
            closeStatusBar();
        }
    }
</script>

<div id="status-bar-wrapper" class="status-bar-wrapper">
    <div class="status-title-wrapper">
        <div class="icon">
            <Icon icon={statusData.icon} color="ps-text-green" />
        </div>

        <div class="title-info">
            <p class="title">
                {statusData.title}
            </p>
            <p class="title-description">
                {statusData.description}
            </p>
        </div>
    </div>

    <div class="items-wrapper">
        {#each statusDataItems as item}
            <div class="each-item">
                <p class="label">
                    {item.key}:
                </p>
                <p class="value">
                    {item.value}
                </p>
            </div>
        {/each}
    </div>
</div>

<style>
    .status-bar-wrapper {
        -moz-animation: 2s display-status;
        -webkit-animation: 2s display-status;
        animation: 2s display-status;

        position: absolute;
        left: 50%;
        bottom: 1%;
        transform: translateX(-50%);

        width: 23vw;
        min-height: 8vw;
        height: fit-content;

        overflow: hidden;

        background-color: var(--color-darkblue);
        border-radius: 0.3vw;

        padding: 1vw 2vw;
        display: flex;
        flex-direction: column;
    }
    @keyframes display-status {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }

    .status-bar-wrapper > .status-title-wrapper {
        display: flex;
        flex-direction: row;
    }

    .status-bar-wrapper > .status-title-wrapper > .icon {
        width: 1.5vw;
        margin-right: 0.5vw;

        font-size: 1.25vw;
    }
    .status-bar-wrapper > .status-title-wrapper > .title-info {
        display: flex;
        flex-direction: column;
        
        text-transform: capitalize;
    } 
    .status-bar-wrapper > .status-title-wrapper > .title-info > .title {
        font-size: 1.3vw;
        font-weight: 500;
        color: var(--color-white);
    } 
    .status-bar-wrapper > .status-title-wrapper > .title-info > .title-description {
        font-size: 0.95vw;
        font-weight: 200;
        color: var(--color-lightgrey);

        margin-top: -0.2vw;
    } 

    .status-bar-wrapper > .items-wrapper {
        margin-left: 2vw;
        margin-top: 0.5vw;
    }
    .status-bar-wrapper > .items-wrapper > .each-item {
        display: flex;
        flex-direction: row;

        word-wrap: break-word;
        flex-wrap: wrap;

        font-size: 0.95vw;
    }
    .status-bar-wrapper > .items-wrapper > .each-item:not(:last-child) {
        margin-bottom: 0.3vw;
    }

    .status-bar-wrapper > .items-wrapper > .each-item > .label {
        color: var(--color-lightgrey);
    }
    .status-bar-wrapper > .items-wrapper > .each-item > .value {
        color: var(--color-green);
        margin-left: 0.3vw;
    }
</style>