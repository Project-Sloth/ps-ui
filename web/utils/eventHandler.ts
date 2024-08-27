import { hideStatusBar, showStatusBar } from '../src/stores/StatusBarStores';
import { hideUi, showComponent, showUi } from '../src/stores/GeneralStores';
import { showInput } from './../src/stores/InputStores';

import { onMount, onDestroy } from 'svelte';
import fetchNui from './fetch';
import { UIComponentsEnum } from './../src/enums/UIComponentsEnum';
import { currentActiveGameDetails, currentGameActive, gameSettings, setupGame } from '../src/stores/GameLauncherStore';
import { showImage } from './../src/stores/ImageStore';
import { addNotification } from './../src/stores/NotificationStore';
import { hideDrawTextMenu, showDrawTextMenu } from '../src/stores/DrawTextStore';
import { closeInteractionMenu, setupInteractionMenu } from '../src/stores/MenuStores';
import { initializeCircleGame, setupCircleGame } from '../src/stores/CircleGameStore';

interface nuiMessage {
    action: string;
    data: {[key: string]: any};
}

export function EventHandler() {
	function mainEvent(event: nuiMessage) {
		showUi.set(true);
		switch (event.data.action) {
			case 'ShowStatusBar':
				showStatusBar(event.data.data as any);
				break;
			case 'UpdateStatusBar':
				showStatusBar(event.data.data as any);
				break;
			case 'HideStatusBar':
				hideStatusBar();
				break;
			case 'ShowMenu':
				setupInteractionMenu(event.data.data as any)
				break;
			case 'HideMenu':
				closeInteractionMenu();
				break;
			case 'ShowInput':
				showInput(event.data.data as any);
				break;
			case 'ShowImage':
				showImage(event.data.data as any);
				break;
			case 'hideUi':
				hideUi();
				break;
			case 'ShowNotification':
				addNotification(event.data.data as any);
				break;
			case 'ShowDrawTextMenu':
				showDrawTextMenu(event.data.data as any);
				break;
			case 'HideDrawTextMenu':
				hideDrawTextMenu();
				break;
			case 'CircleGame':
				initializeCircleGame()
				setupCircleGame(event.data.data)
				break;
			case 'MemoryGame':
			case 'Scramber':
			case 'NumberMaze':
			case 'GameLauncher':
			setupGame(event.data.data as any);
			break;
		}
	}

	onMount(() => window.addEventListener('message', mainEvent));
	onDestroy(() => window.removeEventListener('message', mainEvent));
}

export function handleKeyUp(event: KeyboardEvent) {
	const charCode = event.key;
	if (charCode == 'Escape') {
		showComponent.subscribe((component: UIComponentsEnum) => {
			switch (component) {
				case UIComponentsEnum.Input:
					fetchNui('input-close', { ok: true });
					break;
				case UIComponentsEnum.Menu:
					closeInteractionMenu();
					break;
				case UIComponentsEnum.Image:
					fetchNui('minigame:callback', true);
					break;
				case UIComponentsEnum.Game:
					currentGameActive.set(null);
					currentActiveGameDetails.set(null);
					gameSettings.set({
						game: '',
						gameName: '',
						gameDescription: '',
						amountOfAnswers: 0,
						gameTime: 0,
						maxAnswersIncorrect: 0,
						triggerEvent: '',
					});
					break;
			}
		});
		hideUi();
	}
}
