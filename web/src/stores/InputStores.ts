import { writable, type Writable } from 'svelte/store';
import type { IInput } from './../interfaces/IInput';
import { showComponent, showUi } from './GeneralStores';
import { UIComponentsEnum } from '../enums/UIComponentsEnum';

export const inputStore: Writable<Array<IInput>> = writable([
	{
		id: '1',
		label: 'Label',
		icon: 'fa-solid fa-user',
		placeholder: 'Insert name',
		type: 'text',
	},
	{
		id: '2',
		label: 'Label',
		icon: 'fa-solid fa-user',
		placeholder: 'Placeholder',
		type: 'password',
	},
	{
		id: '3',
		label: 'Label',
		icon: 'fa-solid fa-user',
		placeholder: 'Placeholder',
		type: 'phone',
	},
]);

/** Show the input component */
export function showInput(data: Array<IInput>): void {
	showUi.set(true);
	showComponent.set(UIComponentsEnum.Input);

	inputStore.set([...data]);
}
