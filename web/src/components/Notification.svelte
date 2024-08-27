<script lang="ts">
	import { notifications } from './../stores/NotificationStore';
	import { NotificationIcons, NotificationTypes } from './../enums/NotificationTypesEnum';
</script>

<div class="flex justify-end min-h-screen">
	<div class="flex flex-col mr-4 mt-4 w-[200px]">
		{#each $notifications as notification}
			<div
				class="{notification.type} flex items-center px-4 py-3 mb-1 text-white min-w-full rounded"
			>
				<div class="text-2xl mt-1">
					{#if notification.type === NotificationTypes.Success}
						<i class={NotificationIcons.Success} />
					{:else if notification.type === NotificationTypes.Warning}
						<i class={NotificationIcons.Warning} />
					{:else if notification.type === NotificationTypes.Error}
						<i class={NotificationIcons.Error} />
					{:else if notification.type === NotificationTypes.Info}
						<i class={NotificationIcons.Info} />
					{/if}
				</div>
				<span class="ml-3">{notification.text}</span>
			</div>
		{/each}
	</div>
</div>