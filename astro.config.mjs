// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
    site: 'https://martinmimi.pages.dev',
    output: 'static',
    outDir: './build/output',
    markdown: {
        shikiConfig: {
            theme: 'catppuccin-mocha',
        },
    },
    vite: {
        environments: {
            client: {
                build: {
                    rolldownOptions: {
                        output: {
                            entryFileNames: 'assets/[hash].js',
                            chunkFileNames: 'assets/[hash].js',
                            codeSplitting: {
                                groups: [
                                    {
                                        name: 'three',
                                        test: /node_modules[\\/]three/,
                                        maxSize: 500000,
                                    },
                                ],
                            },
                        },
                    },
                },
            },
        },
    },
    integrations: [sitemap({
        lastmod: new Date(new Date().toDateString()),
        entryLimit: 1000,
    })],
});
