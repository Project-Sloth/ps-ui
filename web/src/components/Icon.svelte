<script lang="ts">
	export let icon: string;
	export let color: string = '';
	export let classes: string = '';
    export let styleColor: string = '';
</script>

<i class="{color} {icon} {classes}" style="color: {styleColor};" />
