import type { UIComponentsEnum } from './../enums/UIComponentsEnum';
import { writable, type Writable } from 'svelte/store';
import { currentGameActive } from './GameLauncherStore';

export const showComponent: Writable<UIComponentsEnum | string> = writable();

export const showUi: Writable<boolean> = writable();
export const isDevMode = false;

export function hideUi(): void {
	showUi.set(false);
	showComponent.set(undefined);
	currentGameActive.set(undefined);
}

export function getRandomArbitrary(min, max) {
	return Math.floor(Math.random() * (max - min) + min);
}

export function convertVwToPx(vw) {
	return (document.documentElement.clientWidth * vw) / 100;
}
