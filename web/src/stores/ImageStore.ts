import type { IImage } from './../interfaces/IImage';
import { writable, type Writable } from 'svelte/store';
import { showComponent, showUi } from './GeneralStores';
import { UIComponentsEnum } from './../enums/UIComponentsEnum';

export const imageStore: Writable<IImage> = writable({ show: false, url: '' });

export function showImage(event: any) {
	showUi.set(true);
	showComponent.set(UIComponentsEnum.Image);
	imageStore.set({
		show: event.show,
		url: event.url,
	});
}
