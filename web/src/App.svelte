<script lang="ts">
	// Svelte
	import { fade } from 'svelte/transition';

	// Stores
	import { isDevMode, showComponent } from './stores/GeneralStores';
	import { showUi } from './stores/GeneralStores';

	// Enums
	import { UIComponentsEnum } from './enums/UIComponentsEnum';

	// PS-UI components
	import GameLauncher from './games/GameLauncher.svelte';
	import { EventHandler, handleKeyUp } from './../utils/eventHandler';
	import Image from './components/Image.svelte';
	import { notificationMock } from './../utils/mockEvent';
	import Notification from './components/Notification.svelte';
  import { GamesEnum } from './enums/GamesEnum';
  import InputComponent from './components/InputComponent.svelte';
  import StatusBarComponent from './components/StatusBarComponent.svelte';
  import DrawTextComponent from './components/DrawTextComponent.svelte';
  import InteractionMenuComponent from './components/InteractionMenuComponent.svelte';
  import CircleGame from './games/CircleGame.svelte';

	EventHandler();
	document.onkeyup = handleKeyUp;

  if(isDevMode) {
    notificationMock();
    const memoryGameData = {
      game: GamesEnum.Memory,
      gameName: 'Memory MiniGame',
      gameDescription: 'Lorem ipsum is placceholder text commonly used in the arachic, print and publishing industries for previewing layouts and visual mockups.',
      amountOfAnswers: 9,
      gameTime: 30, // seconds 
      maxAnswersIncorrect: 0,
      displayInitialAnswersFor: 5, //seconds
      gridSize: 10, //5,6,7,8,9,10 - one of these values as number of rows and columns
      triggerEvent: 'memorygame-callback',
    };
    // setupGame({ data: memoryGameData});

    const scramblerGameData = {
      game: GamesEnum.Scrambler,
      gameName: 'Scrambler MiniGame',
      gameDescription: 'Lorem ipsum is placeholder text commonly used in the arachic, print and publishing industries for previewing layouts and visual mockups.',
      amountOfAnswers: 4, // count of numbers to display
      gameTime: 80, // seconds 
      sets: 'numeric',  // numeric, alphabet, alphanumeric, greek, braille, runes
      changeBoardAfter: 3 //seconds
    };
    // setupGame({ data: scramblerGameData});

    const numberMazeGameData = {
      game: GamesEnum.NumberMaze,
      gameName: 'Number Maze MiniGame',
      gameDescription: 'Lorem ipsum is placeholder text commonly used in the arachic, print and publishing industries for previewing layouts and visual mockups.',
      gameTime: 30, // seconds 
      maxAnswersIncorrect: 2,
      triggerEvent: 'maze-callback',
    };
    // setupGame({ data: numberMazeGameData});

    const numberPuzzleGameData = {
      game: GamesEnum.NumberPuzzle,
      gameName: 'Number Puzzle MiniGame',
      gameDescription: 'Lorem ipsum is placeholder text commonly used in the arachic, print and publishing industries for previewing layouts and visual mockups.',
      gameTime: 3, // seconds 
      maxAnswersIncorrect: 2,
      amountOfAnswers: 5,
      timeForNumberDisplay: 5, // seconds
      triggerEvent: 'var-callback',
    };
    // setupGame({ data: numberPuzzleGameData});

    //input
    const inputData = [
      {
        id: '1',
        label: 'Name',
        icon: 'fa-solid fa-pen',
        placeholder: 'Insert name',
        type: 'text',
      },
      {
        id: '2',
        label: 'Password',
        icon: 'fa-solid fa-lock',
        placeholder: 'Enter password',
        type: 'password',
      },
      {
        id: '3',
        label: 'Phone',
        icon: 'fa-solid fa-phone',
        placeholder: 'Enter phone number',
        type: 'phone',
      },
    ];

    // showInput(inputData);

    const statusBarData = {
			title: 'Area Dominance',
			description: 'Write some description here',
      icon: 'fa-solid fa-circle-info',
			items: [
				{
					key: 'Gang', value: 'Ballas'
				},
				{
					key: 'Dominance', value: '20%'
				}
			],
		};
    // showStatusBar(statusBarData);

    // // double call for status bar
    // setTimeout(() => {
    //   showStatusBar(
    //     {
    //       title: 'Area Check',
    //       description: 'Whats up',
    //       icon: 'fa-solid fa-heart',
    //       items: [
    //         {
    //           key: 'Gang', value: 'Ace'
    //         }
    //       ],
    //     }
    //   )
    // }, 5000);

    const drawTextData = {
      icon: 'fa-solid fa-circle-info',
			keys: 'Press [E] to interact',
      color: 'yellow'
		};
    // showDrawTextMenu(drawTextData);

    // // double call for draw text
    // setTimeout(() => {
    //   showDrawTextMenu(
    //     {
    //       icon: 'fa-solid fa-circle-info',
    //       keys: 'Press [E] to interact and check if the old one exists',
    //       color: ''
    //     }
    //   );
    // }, 5000);

    const interactionMenuData = [
      {
        header: 'Menu item 1',
        text: 'Some text',
        icon: 'fa-solid fa-user',
        color: '#02f1b5',
        callback: '',
        subMenu: null,
      },
      {
        header: 'Menu item 2',
        icon: 'fa-solid fa-user',
        color: '',
        callback: '',
        subMenu: [
          {
            header: 'Submenu1',
            icon: 'fa-solid fa-circle-info',
            color: '#02f1b5',
          },
          {
            header: 'Submenu2',
            icon: 'fa-solid fa-circle-info',
            color: '#02f1b5',
          },
        ],
      },
    ];
    // setupInteractionMenu(interactionMenuData);
  }
</script>

{#if $showUi }
<!-- class="min-h-screen min-w-full"  -->
	  <main transition:fade={{ duration: 100 }} class="main-bg">
	  	{#if $showComponent === UIComponentsEnum.StatusBar}
	  		<StatusBarComponent />
	  	{/if}
    
      {#if $showComponent === UIComponentsEnum.DrawText}
	  		<DrawTextComponent />
	  	{/if}
    
	  	{#if $showComponent === UIComponentsEnum.Menu}
	  		<InteractionMenuComponent />
	  	{/if}
    
	  	{#if $showComponent === UIComponentsEnum.Input}
	  		<InputComponent />
	  	{/if}
    
	  	{#if $showComponent === UIComponentsEnum.Game}
	  		<GameLauncher />
	  	{/if}
    
	  	{#if $showComponent === UIComponentsEnum.Image}
	  		<Image />
	  	{/if}
    
	  	{#if $showComponent === UIComponentsEnum.Notification}
	  		<Notification />
	  	{/if}
      <CircleGame />
	  </main>
{/if}

<style>
  .main-bg {
    height: 100%;
    width: 100%;
    overflow: hidden;
  }
</style>