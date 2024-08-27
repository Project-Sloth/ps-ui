<script lang="ts">
    import { onMount } from "svelte";
    import Icon from "./Icon.svelte";
    import { isDevMode, showComponent, showUi } from "../stores/GeneralStores";
    import { drawTextStore, hideDrawTextMenu, hideDrawTextStore } from "../stores/DrawTextStore";

    let drawTextDataValue:any = {};
    drawTextStore.subscribe((value) => drawTextDataValue = value);

    let hideDrawTextValue = false;
    hideDrawTextStore.subscribe(value => {
        hideDrawTextValue = value;
    });

    let marginLeftVal = '2%';
    let interactionText = [], colorValue = '';
    
    onMount(() => {       
        getColorValue(); 
        handleInteractionText();

        if(isDevMode) {
            setTimeout(() => {
                hideDrawTextMenu();
            }, 10000);
        }
    });

    function getColorValue() {
        switch(drawTextDataValue.color) {
            case "primary":
                colorValue ="#0275d8";
                break;
            case "error":
                colorValue = "#d9534f";
                break;
            case "success":
                colorValue = "#5cb85c";
                break;
            case "warning":
                colorValue = "#f0ad4e";
                break;
            case "info":
                colorValue = "#5bc0de";
                break;
            case "mint":
                colorValue =  "#a1f8c7";
                break;
            default:
                colorValue = "var(--color-green)";
                break;
        }
    }

    function handleInteractionText() {
        let matches = drawTextDataValue.keys.match(/\[(.*?)\]/);
        if (matches) {
            let submatch = matches[0];

            let splitText = drawTextDataValue.keys.split(submatch);
            interactionText = [
                {
                    value: splitText[0],
                    color: 'var(--color-lightgrey)'
                },
                {
                    value: submatch,
                    color: colorValue
                },
                {
                    value: splitText[1],
                    color: 'var(--color-lightgrey)'
                }
            ];
        } else {
            interactionText = [
                {
                    value: drawTextDataValue.keys,
                    color: 'var(--color-lightgrey)'
                }
            ];
        }
    }

    function closeDrawText() {
        const statusWrapperDom = document.getElementById('draw-text-wrapper');
        if(statusWrapperDom) {
            statusWrapperDom.style.animation = '2s slide-left';

            let keyFrames = document.createElement('style');
            
            keyFrames.innerHTML =  `
                @keyframes slide-left {
                    from {
                        margin-left: `+marginLeftVal+`;
                    }
                    to {
                        margin-left: -20%;
                    }
                }

                .draw-text-wrapper {
                    -moz-animation: 2s slide-left;
                    -webkit-animation: 2s slide-left;
                    animation: 2s slide-left;
                }
            `;

            statusWrapperDom.appendChild(keyFrames);

            setTimeout(() => {
                showUi.set(false);
                showComponent.set(null);
                
                drawTextStore.set({
                    // title: '',
                    icon: '',
                    keys: '',
                    color: ''
                });
                hideDrawTextStore.set(false);
            }, 500);
        }
    }

    $: {
        if(hideDrawTextValue) {
            closeDrawText();
        }

        if(drawTextDataValue) {
            handleInteractionText();
        }
    }
</script>

<div id="draw-text-wrapper" class="draw-text-wrapper" style="margin-left:{marginLeftVal};">
    <div class="draw-text-title-wrapper">
        <div class="icon">
            <Icon icon={drawTextDataValue.icon} styleColor={colorValue} />
        </div>

        <div class="title-info">
            <p class="title-description">
                {#each interactionText as text}
                    <p style="color: {text.color};">{text.value}</p>
                {/each}
            </p>
        </div>
    </div>
</div>

<style>
    .draw-text-wrapper {
        -moz-animation: 1s slide-right;
        -webkit-animation: 1s slide-right;
        animation: 1s slide-right;
        
        position: absolute;
        top: 50%;
        transform: translateY(-50%);

        min-width: 10vw;
        width: max-content;

        min-height: 3vw;
        height: fit-content;

        overflow: hidden;

        background-color: var(--color-darkblue);
        border-radius: 0.3vw;

        padding: 0.75vw 1.5vw;
        display: flex;
        flex-direction: column;
    }
    @keyframes slide-right {
        from {
            margin-left: -20%;
        }
        to {
            margin-left: 2%;
        }
    }
    @keyframes slide-left {
        from {
            margin-left: 2%;
        }
        to {
            margin-left: -100%;
        }
    }

    .draw-text-wrapper > .draw-text-title-wrapper {
        display: flex;
        flex-direction: row;
    }

    .draw-text-wrapper > .draw-text-title-wrapper > .icon {
        width: 1.5vw;
        margin: auto 0.75vw auto 0;

        font-size: 1.25vw;
    }
    .draw-text-wrapper > .draw-text-title-wrapper > .title-info {
        display: flex;
        flex-direction: column;
        
        text-transform: capitalize;
    } 

    .draw-text-wrapper > .draw-text-title-wrapper > .title-info > .title-description {
        font-size: 1vw;
        font-weight: 300;
        color: var(--color-lightgrey);

        display: flex;
        flex-direction: row;
        word-wrap: break-word;
        flex-wrap: wrap;

        margin-top: auto;
        margin-bottom: auto;
    }
    .draw-text-wrapper > .draw-text-title-wrapper > .title-info > .title-description  > p {
        margin-right: 0.25vw;
    }
</style>