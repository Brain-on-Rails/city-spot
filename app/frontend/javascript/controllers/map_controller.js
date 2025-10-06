import {Controller} from "@hotwired/stimulus"
import {mount, unmount} from "svelte";
import MapComponent from "../components/Map.svelte";

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

        this.listenToMapClicks();
    }

    listenToMapClicks() {
        this.mapContainerTarget.addEventListener('map:add-marker', (event) => {
            this.updateFormCoordinates(event.detail.lat, event.detail.lng)
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