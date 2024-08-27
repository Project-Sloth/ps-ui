<script lang="ts">
    import { closeInteractionMenu, menuStore } from "../stores/MenuStores";
    import Icon from "./Icon.svelte";
    import fetchNui from "../../utils/fetch";
    import { isDevMode } from "../stores/GeneralStores";

    let menuData:Array<any> = $menuStore;
    let selectedMenuItem = null;
    let subMenu = null;

    let subMenuTextColorOverride = {
        id: null, color: 'black'
    };
    let menuTextColorOverride = {
        id: null, color: 'black'
    };

    function handleMenuSelection(selectedMenu) {
        selectedMenuItem = selectedMenu;

        if(selectedMenu) {
            
            if(!selectedMenu.subMenu && !isDevMode) {
                fetchNui('MenuSelect', {data :selectedMenu});
                closeInteractionMenu();
            } else {
                subMenu = selectedMenuItem.subMenu;
            }
        }
    }

    function handleSubMenuSelection(selectedSubMenu) {
        const formData = {
            data:selectedSubMenu
        };
        if(!isDevMode) {
            fetchNui('MenuSelect', formData);
            closeInteractionMenu();
        }
    }

    function handleItemHover(itemId, index, color, action='enter', isSubMenu = false) {
        const itemDom = document.getElementById(itemId);
        if(action === 'enter') {
            if(isSubMenu) {
                itemDom.style.backgroundColor = color || 'var(--color-green)';
                subMenuTextColorOverride.id = index;
            } else {
                itemDom.style.backgroundColor = color || 'var(--color-green)';
                menuTextColorOverride.id = index;
            }
        } else {
            itemDom.style.backgroundColor = 'var(--color-darkblue)';
            subMenuTextColorOverride.id = null;
            menuTextColorOverride.id = null;
        }
    }
</script>

<div class="menu-base-wrapper">
    <div class="screen-base">
        {#if !selectedMenuItem}
            <div class="header-slot" style="border: 3px solid var(--color-green);">
                <img src="./images/ps-logo.png" alt="ps-logo" />
            </div>

            <div class="screen-body">
                {#each menuData as menu, index}
                    <div id={"menu-"+index} class="each-panel" 
                    on:mouseenter={() => handleItemHover("menu-"+index, index, menu.color, 'enter', false)} 
                    on:mouseleave={() => handleItemHover("menu-"+index, index, menu.color, 'leave', false)} 
                    on:click={() => handleMenuSelection(menu)}>
                        <div class="menu-icon">
                            <Icon icon={menu.icon} styleColor={menuTextColorOverride.id === index ? menuTextColorOverride.color : menu?.color || 'var(--color-green)'} />
                        </div>
                        <div class="menu-details">
                            <p class="header" style="color: {menuTextColorOverride.id === index ? menuTextColorOverride.color : 'var(--color-white)'};">{menu.header}</p>
                            {#if menu.hasOwnProperty('text')}
                                <p class="text" style="color: {menuTextColorOverride.id === index ? menuTextColorOverride.color : 'var(--color-lightgrey)'};">{menu.text}</p>
                            {/if}
                        </div>
                        {#if menu?.subMenu}
                            <div class="chevron" style="color: {menuTextColorOverride.id === index ? menuTextColorOverride.color : 'var(--color-white)'};">
                                <i class="fa-solid fa-chevron-right"></i>
                            </div>
                        {/if}
                    </div>
                {/each}
            </div>
        {:else if selectedMenuItem.hasOwnProperty('subMenu') && selectedMenuItem.subMenu}
            <div class="submenu-header-slot" on:click={() => handleMenuSelection(null)}>
                <i class="fa-solid fa-chevron-left left-chevron"></i>
                <p class="main-menu">Main Menu</p>
            </div>

            <div class="screen-body">
                {#each subMenu as menu, index}
                    <div id={"sub-menu-"+index} class="each-panel" 
                    on:mouseenter={() => handleItemHover("sub-menu-"+index, index, menu.color, 'enter', true)} 
                    on:mouseleave={() => handleItemHover("sub-menu-"+index, index, menu.color, 'leave', true)} 
                    on:click={() => handleSubMenuSelection(menu)}>
                        <div id={"menu-icon-"+index} class="menu-icon">
                            <Icon icon={menu.icon} styleColor={subMenuTextColorOverride.id === index ? subMenuTextColorOverride.color : menu.color || 'var(--color-green)'} />
                        </div>
                        <div class="menu-details">
                            <p class="header" style="color: {subMenuTextColorOverride.id === index ? subMenuTextColorOverride.color : 'var(--color-white)'};">{menu.header}</p>
                            {#if menu.hasOwnProperty('text')}
                                <p class="text" style="color: {subMenuTextColorOverride.id === index ? subMenuTextColorOverride.color : 'var(--color-lightgrey)'};">{menu.text}</p>
                            {/if}
                        </div>
                    </div>
                {/each}
            </div>
        {/if}
    </div>
    
</div>

<style>
.menu-base-wrapper {
    /* centering the view */
    position: absolute;
    left: 70%;  
    top: 40%;
    -webkit-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);  

    width: 20vw;
    height: 30vw;
    /* min-height: 4vw;
    height: fit-content; */

    overflow: hidden;
    /* border: 0.1px solid red; */
}

.menu-base-wrapper > .screen-base {
    height: 100%;
    /* border: 0.1px solid yellow; */

    display: flex;
    flex-direction: column;
}

.menu-base-wrapper > .screen-base > .header-slot {
    background-color: var(--color-darkblue);
    border-radius: 0.3vw;

    padding: 0.5vw 2vw;
    display: flex;
    flex-direction: row;

    min-height: 3vw;
    height: fit-content;
}
.menu-base-wrapper > .screen-base > .header-slot > img {
    height: 4vw;
    align-self: center;
}

.menu-base-wrapper > .screen-base > .submenu-header-slot {
    min-height: 4vw;
    height: max-content;

    background-color: var(--color-darkblue);
    border-radius: 0.3vw;
    color: var(--color-white);

    padding: 0.3vw 1vw;
    cursor: pointer;

    display: flex;
    flex-direction: row;
}
.menu-base-wrapper > .screen-base > .submenu-header-slot > .left-chevron {
    margin-top: auto;
    margin-bottom: auto;
    margin-right: 0.5vw;

    width: 1.5vw;
    
    font-size: 1.1vw;
}
.menu-base-wrapper > .screen-base > .submenu-header-slot > .main-menu {
    font-weight: 500;
    font-size: 1.25vw;

    margin-top: auto;
    margin-bottom: auto;
}

.menu-base-wrapper > .screen-base > .screen-body {
    margin-top: 0.3vw;
    height: 100%;
    overflow-y: auto;
    
    display: flex;
    flex-direction: column;
    /* border: 0.1px solid blue; */
}

.menu-base-wrapper > .screen-base > .screen-body > .each-panel {
    min-height: 4vw;
    height: max-content;

    background-color: var(--color-darkblue);
    border-radius: 0.3vw;

    padding: 0.5vw 1vw;
    cursor: pointer;

    display: flex;
    flex-direction: row;
}
.menu-base-wrapper > .screen-base > .screen-body > .each-panel:not(:last-child) {
    margin-bottom: 0.3vw;
}

.menu-base-wrapper > .screen-base > .screen-body > .each-panel > .menu-icon {
    margin-top: auto;
    margin-bottom: auto;
    margin-right: 0.5vw;

    width: 1.5vw;
    
    font-size: 1vw;
}

.menu-base-wrapper > .screen-base > .screen-body > .each-panel > .menu-details {
    display: flex;
    flex-direction: column;
    margin-top: auto;
    margin-bottom: auto;
}

.menu-base-wrapper > .screen-base > .screen-body > .each-panel > .menu-details > .header {
    font-size: 0.8vw;
    white-space: nowrap;
    /* color: var(--color-white); */
}

.menu-base-wrapper > .screen-base > .screen-body > .each-panel > .menu-details > .text {
    font-size: 0.6vw;
    white-space: nowrap;
    /* color: var(--color-lightgrey); */
}

.menu-base-wrapper > .screen-base > .screen-body > .each-panel > .chevron {
    margin-left: 72%;
    font-size: 1vw;
    /* color: var(--color-white); */

    margin-top: auto;
    margin-bottom: auto;
}
</style>