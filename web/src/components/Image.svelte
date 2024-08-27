<script lang="ts">
	import { imageStore } from './../stores/ImageStore';
	import { fly } from 'svelte/transition';
</script>

{#if $imageStore.show}
	<div class="flex items-center justify-center min-h-screen" transition:fly="{{y: +400}}">
		<div class="flex items-center flex-col ps-bg-darkblue p-10 shadow-md shadow-gray-800 rounded-md">
			<!-- svelte-ignore a11y-img-redundant-alt -->
			<img src={$imageStore.url} alt="Image Placeholder" />
		</div>
	</div>
{/if}
