import { UIComponentsEnum } from '../enums/UIComponentsEnum';
import { GamesEnum } from '../enums/GamesEnum';
import { ConnectingGameMessageEnum } from '../enums/GameConnectionMessages';
import { hideUi, isDevMode, showComponent } from './GeneralStores';
import type { IGameSettings } from './../interfaces/IGameSettings';
import { writable, type Writable } from 'svelte/store';
import fetchNui from './../../utils/fetch';

export const gameSettings: Writable<IGameSettings> = writable({
	game: '',
	gameName: '',
	gameDescription: '',
	amountOfAnswers: 0,
	gameTime: 0,
	maxAnswersIncorrect: 0,
});
export const currentGameActive: Writable<GamesEnum> | undefined = writable();
export const currentActiveGameDetails: Writable<any> | undefined = writable();
export const connectionText: Writable<ConnectingGameMessageEnum> = writable();
export const showLoading: Writable<boolean> = writable(true);

export function setupGame(data): void {
	const settings = data;
	currentActiveGameDetails.set(settings);

	switch (settings.game) {
		case GamesEnum.Memory: {
			showComponent.set(UIComponentsEnum.Game);
			
			currentGameActive.set(GamesEnum.Memory);
			connectionText.set(ConnectingGameMessageEnum.Connecting);

			gameSettings.set({
				game: GamesEnum.Memory,
				gameName: settings.gameName,
				gameDescription: settings.gameDescription,
				gameTime: settings.gameTime || 2,// 1000 = 10 seconds 
				amountOfAnswers: settings.amountOfAnswers || 15,
				maxAnswersIncorrect: settings.maxAnswersIncorrect || 2
			});

			break;
		}

		case GamesEnum.Scrambler: {
			showComponent.set(UIComponentsEnum.Game);
			
			currentGameActive.set(GamesEnum.Scrambler);
			connectionText.set(ConnectingGameMessageEnum.Connecting);

			gameSettings.set({
				game: GamesEnum.Scrambler,
				gameName: settings.gameName,
				gameDescription: settings.gameDescription,
				gameTime: settings.gameTime || 2,// 1000 = 10 seconds 
				amountOfAnswers: settings.amountOfAnswers || 4,
				maxAnswersIncorrect: settings.maxAnswersIncorrect || 0,
			});

			break;
		}

		case GamesEnum.NumberMaze: {
			showComponent.set(UIComponentsEnum.Game);
			
			currentGameActive.set(GamesEnum.NumberMaze);
			connectionText.set(ConnectingGameMessageEnum.Connecting);

			gameSettings.set({
				game: GamesEnum.NumberMaze,
				gameName: settings.gameName,
				gameDescription: settings.gameDescription,
				gameTime: settings.gameTime || 2,// 1000 = 10 seconds 
				amountOfAnswers: settings.amountOfAnswers || 4,
				maxAnswersIncorrect: settings.maxAnswersIncorrect || 0,
			});
			break;
		}

		case GamesEnum.NumberPuzzle: {
			showComponent.set(UIComponentsEnum.Game);
			
			currentGameActive.set(GamesEnum.NumberPuzzle);
			connectionText.set(ConnectingGameMessageEnum.Connecting);

			gameSettings.set({
				game: GamesEnum.NumberPuzzle,
				gameName: settings.gameName,
				gameDescription: settings.gameDescription,
				gameTime: settings.gameTime || 2,// 1000 = 10 seconds 
				amountOfAnswers: settings.amountOfAnswers || 4,
				maxAnswersIncorrect: settings.maxAnswersIncorrect || 0,
			});
			break;
		}
	}
}

export function closeGame(isSuccess: boolean): void {
	if(!isDevMode) {
		fetchNui('minigame:callback', isSuccess);
	}
	closeUi();
}

export function closeUi() {
	hideUi();
	currentGameActive.set(null);
	currentActiveGameDetails.set(null);
	gameSettings.set({
		game: '',
		gameName: '',
		gameDescription: '',
		amountOfAnswers: 0,
		gameTime: 0,
		maxAnswersIncorrect: 0,
	});
}