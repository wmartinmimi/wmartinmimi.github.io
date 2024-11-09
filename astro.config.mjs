// @ts-check
import { defineConfig } from 'astro/config';

// https://astro.build/config
export default defineConfig({
    site: 'https://wmartinmimi.github.io',
    output: 'static',
    markdown: {
        shikiConfig: {
            theme: 'catppuccin-mocha',
        },
    },
});
