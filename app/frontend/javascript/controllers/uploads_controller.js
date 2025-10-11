import { Controller } from "@hotwired/stimulus"
import { mount, unmount } from "svelte";
import Uploads from "@/javascript/components/uploads/Uploads.svelte";

export default class extends Controller {
    static values = {
        formId: String,
        csrfToken: String,
        uploadsUrl: String,
        uploadsToken: String,
        modelName: String
    }
    static targets = ["container"]

    connect() {
        this.svelteInstance = mount(Uploads, {
            target: this.containerTarget,
            props: {
                root: this.containerTarget,
                formId: this.formIdValue,
                csrfToken: this.csrfTokenValue,
                uploadsUrl: this.uploadsUrlValue,
                uploadsToken: this.uploadsTokenValue,
                modelName: this.modelNameValue,
            }
        })
    }

    disconnect() {
        if (this.svelteInstance) unmount(this.svelteInstance);
    }
}