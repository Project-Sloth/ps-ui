export interface IMenu {
	header: string;
	text?: string;
	icon: string;
	color: string;
	callback: string;
	subMenu: Array<null|ISubMenu>;
};

export interface ISubMenu {
	header: string;
	text?: string;
	icon: string;
	color: string;
};
