import { writable, type Writable } from 'svelte/store';
import type { IStatusBar } from '../interfaces/IStatusBar';
import { showComponent, showUi } from './GeneralStores';
import { UIComponentsEnum } from '../enums/UIComponentsEnum';

export const statusBarStore: Writable<IStatusBar> = writable({
	title: '',
	description: '',
	items: [],
	icon: '',
});

export const hideStatusBarStore: Writable<any> = writable(false);

export function showStatusBar(data: IStatusBar) {
	showUi.set(true);
	showComponent.set(UIComponentsEnum.StatusBar);
	
	statusBarStore.set({
		title: data.title,
		description: data.description,
		items: data.items,
		icon: data.icon || 'fa-solid fa-circle-info',
	});
}

export function hideStatusBar() {
	hideStatusBarStore.set(true);
}
