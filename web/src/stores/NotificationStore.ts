import type { INotification } from 'src/interfaces/INotification';
import { writable, type Writable } from 'svelte/store';
import { showComponent } from './GeneralStores';
import { UIComponentsEnum } from './../enums/UIComponentsEnum';

export const notifications: Writable<Array<INotification>> = writable([]);

export function addNotification(newNotification: INotification): void {
	showComponent.set(UIComponentsEnum.Notification);
	notifications.update((currentNotifications) => {
		const updatedNotifications = [...currentNotifications, newNotification];
		return updatedNotifications;
	});

	const unsubscribe = notifications.subscribe((data: Array<INotification>) => {
		data.forEach((notification: INotification) => {
			setTimeout(() => {
				removeNotification(notification);
			}, notification.length);
		});
	});
	unsubscribe();
}

function removeNotification(notification: INotification): void {
	notifications.update((currentNotifications) => {
		const updatedNotifications = currentNotifications.filter((n) => n !== notification);
		return updatedNotifications;
	});
}
