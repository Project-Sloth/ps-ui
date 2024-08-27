import { writable } from 'svelte/store';
import CircleGame from '../games/CircleGame.svelte';

const circleGameStore = writable<CircleGame | null>(null);

export function initializeCircleGame() {
    circleGameStore.update(component => {
        if (!component) {
            const newComponent = new CircleGame({
                target: document.body
            });
            return newComponent;
        }
        return component;
    });
}

export function setupCircleGame(data: { circles?: number; time?: number }) {
    circleGameStore.update(component => {
        if (component) {
            component.setupCircleGame(data);
        }
        return component;
    });
}
