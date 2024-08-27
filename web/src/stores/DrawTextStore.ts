import { writable, type Writable } from 'svelte/store';
import { showComponent, showUi } from './GeneralStores';
import { UIComponentsEnum } from '../enums/UIComponentsEnum';
import type { IDrawText } from '../interfaces/IDrawText';

export const drawTextStore: Writable<IDrawText> = writable({
	// title: '',
	icon: '',
	keys: '',
	color: ''
});

export const hideDrawTextStore: Writable<any> = writable(false);

export function showDrawTextMenu(data: IDrawText) {
	showUi.set(true);
	showComponent.set(UIComponentsEnum.DrawText);
	
	drawTextStore.set({
		// title: data.title,
		icon: data.icon || 'fa-solid fa-circle-info',
		keys: data.keys,
		color: data.color || 'var(--color-green)'
	});
}

export function hideDrawTextMenu() {
	hideDrawTextStore.set(true);
}
