<script>
    import {onMount, onDestroy} from 'svelte';
    import L from 'leaflet';
    import 'leaflet/dist/leaflet.css';


    export let root;
    export let fullscreen = true;
    export let clickable = false;

    let map;
    let mapContainer;
    let marker;
    const url = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

    onMount(() => {
        map = L.map(mapContainer).setView([51.505, -0.09], 13);
        L.tileLayer(url, {
            maxZoom: 18,
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        }).addTo(map);

        if (clickable) enableMapClickInteraction();
    })

    function enableMapClickInteraction() {
        map.on('click', (e) => {
            addMarker(e.latlng.lat, e.latlng.lng);
            root.dispatchEvent(
                new CustomEvent('map:add-marker', {
                    detail: {
                        lat: e.latlng.lat,
                        lng: e.latlng.lng
                    },
                })
            )
        });
    }

    function addMarker(lat, lng) {
        if (marker) {
            map.removeLayer(marker);
        }
        marker = L.marker([lat, lng]).addTo(map);
    }

    onDestroy(() => {

    })

</script>

<div class="map" class:fullscreen={fullscreen} bind:this={mapContainer}></div>

<style>
    .map {
        z-index: 0;
        height: calc(50dvh - (4rem + env(safe-area-inset-bottom)));
        width: 100%;
    }

    .fullscreen {
        height: calc(100dvh - (4rem + env(safe-area-inset-bottom)));
        width: 100vw;
    }
</style>