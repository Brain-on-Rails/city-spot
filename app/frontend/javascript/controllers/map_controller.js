import {Controller} from "@hotwired/stimulus"
import {mount, unmount} from "svelte";
import MapComponent from "../components/Map.svelte";
import {coordinates} from "../components/mapSignal.svelte.js"

export default class extends Controller {
    static values = {
        fullscreen: {type: Boolean, default: true}, clickable: {type: Boolean, default: false}
    }
    static targets = ["mapContainer", "lat", "lng", "form"]

    connect() {
        this.svelteInstance = mount(MapComponent, {
            target: this.mapContainerTarget, props: {
                fullscreen: this.fullscreenValue,
                clickable: this.clickableValue,
                root: this.mapContainerTarget,
            }
        })

        if (this.clickableValue) {
            this.listenToMapClicks();
            this.listenToLatLngInputChanges();
        }
    }

    listenToMapClicks() {
        this.mapContainerTarget.addEventListener('map:add-marker', (event) => {
            this.updateFormCoordinates(event.detail.lat, event.detail.lng)
        })
    }

    listenToLatLngInputChanges() {
        this.latTarget.addEventListener('input', (event) => {
            coordinates.lat = event.target.value;
        })
        this.lngTarget.addEventListener('input', (event) => {
            coordinates.lng = event.target.value;
        })
    }

    updateFormCoordinates(lat, lng) {
        this.latTarget.value = lat;
        this.lngTarget.value = lng;
    }

    disconnect() {
        if (this.svelteInstance) unmount(this.svelteInstance);
    }
}