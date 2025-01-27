import { defineConfig } from "vite";
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'
import * as path from "node:path";
import {globSync} from "node:fs";

const getFiles = (): {[key: string]: string} => {
    const files = globSync(['./assets/**/*/*.ts', './assets/**/*/*.js', './assets/css/app.css']);

    const inputs: {[key: string]: string} = {};

    files.forEach(filePath => {
        const paths = filePath.split(path.sep)
        const filename = paths.pop()?.split('.')?.reverse()?.pop();

        if (!filename) {
            throw new Error(`something is wrong in: ${filePath}`)
        }

        paths.reverse().pop()
        paths.reverse()

        const output = path.join(...paths, filename);

        if (Object.keys(inputs).includes(output)) {
            throw new Error(`multiple definition for output: ${output}`);
        }

        Object.assign(inputs, {[output]: filePath})
    })

    return inputs;
};

export default defineConfig({
    build: {
        cssMinify: true,
        rollupOptions: {
            output: {
              assetFileNames: '[name][extname]', // css
              entryFileNames: '[name].js',
            },
            input: getFiles()
        }
    },
    plugins: [
        tailwindcss(),
        vue()
    ]
});
