import type { NotificationTypes } from './../enums/NotificationTypesEnum';

export interface INotification {
	text: string;
	type: NotificationTypes;
	icon: string;
	length: number;
}
