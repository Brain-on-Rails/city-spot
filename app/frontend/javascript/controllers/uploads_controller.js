import { Controller } from "@hotwired/stimulus"
import { mount, unmount } from "svelte";
import Uploads from "@/javascript/components/Uploads.svelte";

export default class extends Controller {
    static values = {
        formId: String,
    }
    static targets = ["container"]

    connect() {
        this.svelteInstance = mount(Uploads, {
            target: this.containerTarget,
            props: {
                root: this.containerTarget,
                formId: this.formIdValue,
            }
        })
    }

    disconnect() {
        if (this.svelteInstance) unmount(this.svelteInstance);
    }
}