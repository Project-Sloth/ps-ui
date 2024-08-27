import { defineConfig } from 'vite';
import { svelte } from '@sveltejs/vite-plugin-svelte';
import postcss from './postcss.config.js';
import { minify } from 'html-minifier';

const minifyHtml = () => {
	return {
		name: 'html-transform',
		transformIndexHtml(html) {
			return minify(html, {
				collapseWhitespace: true,
			});
		},
	};
};

// https://vitejs.dev/config/
export default defineConfig({
	css: {
		postcss,
	},
	plugins: [svelte(), minifyHtml()],
	test: {
		globals: true,
		environment: 'jsdom',
	},
	base: './', // fivem nui needs to have local dir reference
	build: {
		minify: true,
		emptyOutDir: true,
		outDir: '../web/build',
		assetsDir: './',
		rollupOptions: {
			output: {
				// By not having hashes in the name, you don't have to update the manifest, yay!
				entryFileNames: `[name].js`,
				chunkFileNames: `[name].js`,
				assetFileNames: `[name].[ext]`,
			},
		},
	},
});
