import { mount } from 'svelte'
import Hello from './Hello.svelte'
import Map from './Map.svelte'



document.addEventListener('DOMContentLoaded', () => {
    const mapEl = document.getElementById('svelte-map');
    mount(Map, {
        target: mapEl,
        props: {
        },
    });
});
