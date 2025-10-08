import { Controller } from "@hotwired/stimulus"
import { mount, unmount } from "svelte";
import ImagePreview from "../components/ImagePreview.svelte";

export default class extends Controller {
    static targets = ["input", "previewContainer"]

    connect() {
        this.sveleteInstance = mount(ImagePreview, {
            target: this.previewContainerTarget,
            props: {
                input: this.inputTarget,
                root: this.previewContainerTarget,
            }
        })
    }

    disconnect() {
        if (this.svelteInstance) unmount(this.svelteInstance);
    }
}