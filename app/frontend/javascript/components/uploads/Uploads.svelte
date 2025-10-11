<script>
    import {v4 as uuidv4} from 'uuid';
    import {onMount} from 'svelte';
    import {scale, fade} from 'svelte/transition';
    import {SvelteMap} from "svelte/reactivity";
    // import lightGallery from 'lightgallery';
    // import lgZoom from 'lightgallery/plugins/zoom';
    // import lgThumbnail from 'lightgallery/plugins/thumbnail';


    let uploads = new SvelteMap();
    let errors = $state([]);
    let {csrfToken, uploadsToken, uploadsUrl, modelName} = $props();

    onMount(() => {
    })

    async function handleFileInput(event) {
        const files = Array.from(event.target.files)
        files.map(async file => {
            file.id = uuidv4();
            showFileLoading(file);
            try {
                const result = await uploadFile({file, uploadsToken, csrfToken, url: uploadsUrl})
                pinImage(file, result)
            } catch (error) {
                errors.push(error);
                console.error('Error uploading file:', error);
                unpinImage(file.id);
            }
        })
    }

    function pinImage(file, result) {
        uploads.set(file.id, {file, loading: false, result});
        addSingedIdToForm(file.id);
    }

    function addSingedIdToForm(id) {
        const form = document.querySelector('form');
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = `${modelName}[images][]`;
        input.value = uploads.get(id).result.signed_id;
        input.id = id
        form.appendChild(input);
    }

    function unpinImage(id) {
        uploads.delete(id);
        document.getElementById(id).remove();
    }

    async function uploadFile({file, uploadsToken, csrfToken, url}) {
        const formData = new FormData();
        formData.append('file', file);
        formData.append('token', uploadsToken);

        const response = await fetch(uploadsUrl, {
            method: 'POST',
            body: formData,
            headers: {
                'X-CSRF-Token': csrfToken,
            }
        })

        const data = await response.json();

        if (!response.ok) throw new Error(data.errors || 'Upload failed');

        return data;
    }

    function showFileLoading(file) {
        uploads.set(file.id, {file, loading: true});
    }

</script>

{#each errors as error}
    <div role="alert" class="alert alert-error my-4">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 shrink-0 stroke-current" fill="none"
             viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                  d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <span>{error}</span>
    </div>
{/each}

<div class="grid grid-cols-[repeat(auto-fit,minmax(5rem,1fr))] items-start gap-4">
    {#each uploads.entries() as [id, upload] (id)}
        <div in:scale={{duration:1000}}>
            {#if upload.loading}

                <div class="card card-compact h-full min-h-20 w-auto bg-base-100 shadow-xl relative">
                    <div class="card-body justify-center items-center">
                        <span class="loading loading-ring loading-xl text-success"></span>
                    </div>
                </div>
            {:else}
                <div in:scale={{duration:500}} class="card card-compact w-auto bg-base-100 shadow-xl relative">
                    <button aria-label="delete image"
                            onclick="{() => unpinImage(id)}"
                            class="z-50 btn p-2 badge badge-warning hover:badge-error active:shadow-none absolute top-[-0.5rem] right-[-0.5rem]">
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16" fill="currentColor" class="size-4">
                            <path fill-rule="evenodd"
                                  d="M5 3.25V4H2.75a.75.75 0 0 0 0 1.5h.3l.815 8.15A1.5 1.5 0 0 0 5.357 15h5.285a1.5 1.5 0 0 0 1.493-1.35l.815-8.15h.3a.75.75 0 0 0 0-1.5H11v-.75A2.25 2.25 0 0 0 8.75 1h-1.5A2.25 2.25 0 0 0 5 3.25Zm2.25-.75a.75.75 0 0 0-.75.75V4h3v-.75a.75.75 0 0 0-.75-.75h-1.5ZM6.05 6a.75.75 0 0 1 .787.713l.275 5.5a.75.75 0 0 1-1.498.075l-.275-5.5A.75.75 0 0 1 6.05 6Zm3.9 0a.75.75 0 0 1 .712.787l-.275 5.5a.75.75 0 0 1-1.498-.075l.275-5.5a.75.75 0 0 1 .786-.711Z"
                                  clip-rule="evenodd"/>
                        </svg>
                    </button>
                    <img src="{upload.result.url}" alt="{upload.file.name}"
                         class="z-10 w-full h-full min-h-20 min-w-10 object-cover"/>
                </div>
            {/if}
        </div>
    {/each}
    <label class="btn btn-success self-center btn-xl">
        +
        <input type="file" accept="image/*" onchange="{handleFileInput}" style="display:none;" multiple>
    </label>
</div>

