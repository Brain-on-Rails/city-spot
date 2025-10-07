<script>
    import {onMount, onDestroy} from 'svelte';
    import L from 'leaflet';
    import 'leaflet/dist/leaflet.css';
    import {coordinates} from './mapSignal.svelte.js'


    let {
        root,
        fullscreen = true,
        clickable = false,
    } = $props();

    let map;
    let mapContainer;
    let marker;
    const url = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    let debounceTimer;

    onMount(() => {
        map = L.map(mapContainer).setView([51.505, -0.09], 13);
        L.tileLayer(url, {
            maxZoom: 18,
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
        }).addTo(map);

        if (clickable) enableMapClickInteraction();
    })

    $effect(() => {
        const {lat, lng} = coordinates;
        clearTimeout(debounceTimer);
        if (lat && lng) {
            debounceTimer = setTimeout(() => {
                updateMarker(lat, lng);
            }, 1000)
        }
    })

    function enableMapClickInteraction() {
        map.on('click', (e) => {
            updateMarker(e.latlng.lat, e.latlng.lng);
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

    function updateMarker(lat, lng) {
        if (marker) {
            map.removeLayer(marker);
        }
        marker = L.marker([lat, lng]).addTo(map);
        map.setView([lat, lng], map.getZoom());
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