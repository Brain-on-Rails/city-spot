<script>
import { onMount, onDestroy } from 'svelte';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

let map;
let mapContainer;
const url = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

onMount(() => {
    map = L.map(mapContainer).setView([51.505, -0.09], 13);
    L.tileLayer(url, {
        maxZoom: 18,
        attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
    }).addTo(map);
})

onDestroy(() => {

})

</script>

<div class="map" bind:this={mapContainer}></div>

<style>
    .map {
        height: 80vh;
        width: 100vw;
    }
</style>