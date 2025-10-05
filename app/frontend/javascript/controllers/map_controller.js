import {Controller} from "@hotwired/stimulus"
import {mount, unmount} from "svelte";
import MapComponent from "../components/Map.svelte";

export default class extends Controller {
    static values = {
        fullscreen: { type: Boolean, default: true }
    }

    connect() {
        this.svelteInstance = mount(MapComponent, {
            target: this.element,
            props: {
                fullscreen: this.fullscreenValue,
            }
        })
    }

    disconnect() {
        if (this.svelteInstance) unmount(this.svelteInstance);
    }
}