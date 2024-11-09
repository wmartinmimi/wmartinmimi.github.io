// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
    site: 'https://wmartinmimi.github.io',
    output: 'static',
    outDir: 'docs',
    markdown: {
        shikiConfig: {
            theme: 'catppuccin-mocha',
        },
    },
    integrations: [sitemap({
        lastmod: new Date(new Date().toDateString()),
    })],
});
