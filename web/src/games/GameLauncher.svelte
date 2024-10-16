<script lang="ts">
	import { onDestroy, onMount } from 'svelte';
	import Skull from '../assets/svgs/Skull.svelte';
	('./../../utils/mockEvent');
	import { connectionText, showLoading } from '../stores/GameLauncherStore';
    import { ConnectingGameMessageEnum } from '../enums/GameConnectionMessages';
    import GameBase from './GameBase.svelte';

	const skullColor: string = '#02f1b5';

	let loadingBar: HTMLDivElement;
	let gameLoaded = false;

	/** Asynchronously connects to a game and resolves the Promise when completed.
	 * Uses a loading bar to show progress, incrementing by 1% every 30ms until it reaches 100%.
	 *
	 * @returns Promise that resolves when the loading bar reaches 100%.
	 */
	async function connectToGame(): Promise<void> {
		return new Promise((resolve) => {
			let width = 0;
			let interval = setInterval(() => {
				width++;
				loadingBar.style.width = `${width}%`;

				if (width === 100) {
					clearInterval(interval);
					resolve();
				}
			}, 30);
		});
	}

	// Call init() on mount
	onMount(async () => {
		// Show a loading indicator while connecting to the game server
		connectionText.set(ConnectingGameMessageEnum.Connecting);
		showLoading.set(true);

		// Connect to the game server
		await connectToGame();

		// Hide loading indicator when completed connecting to the game server
		connectionText.set(ConnectingGameMessageEnum.Connected);
		setTimeout(() => {
			showLoading.set(false);
			gameLoaded = true;
		}, 2000);
	});

	onDestroy(async () => {
		gameLoaded = false
	})
</script>

{#if $showLoading}
	<div class="flex min-h-screen justify-center items-center">
		<div
			class="flex flex-col h-[400px] w-[700px] ps-bg-darkblue shadow-md shadow-black justify-center items-center"
		>
			<span class="w-40"><Skull color={skullColor} /></span>
			<p class="text-white text-3xl mt-2">{$connectionText}</p>

			<!-- Loading wrapper -->
			<div class="flex mt-10 ps-border-green border-4 w-[80%] h-10">
				<!-- Loading bar progress -->
				<div
					bind:this={loadingBar}
					class="ps-bg-green opacity-40 will-change-auto w-0"
				>
				</div>
			</div>
		</div>
	</div>
{/if}

{#if !$showLoading && gameLoaded}
	<GameBase />
{/if}