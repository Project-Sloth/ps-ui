import type { IMenu } from './../interfaces/IMenu';
import { writable, type Writable } from 'svelte/store';
import { hideUi, showComponent, showUi } from './GeneralStores';
import { UIComponentsEnum } from '..//enums/UIComponentsEnum';
import fetchNui from '../../utils/fetch';

export const menuStore: Writable<Array<IMenu>> = writable([]);

export const menuIdShown: Writable<string> = writable();

export function setupInteractionMenu(data: Array<IMenu>): void {
	showUi.set(true);
	showComponent.set(UIComponentsEnum.Menu);
	menuStore.set(data.menuData);
}

export function closeInteractionMenu(): void {
	showUi.set(false);
	showComponent.set(null);
	menuStore.set([
		{
			header: '',
			text: '',
			icon: '',
			color: '',
			callback: '',
			subMenu: null,
		}
	]);
	fetchNui('menuClose');
	hideUi();
}