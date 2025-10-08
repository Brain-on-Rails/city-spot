
<script>
    import {onMount, onDestroy} from 'svelte';

    let {
        input,
        previewContainer,
    } = $props();

    let filesetInput = $state(null);


    onMount(() => {
        listenToInputChanges();
    })

    function listenToInputChanges() {
        input.addEventListener('change', (event) => {
            filesetInput = Array.from(event.target.files).map(file => ({
                file,
                name: file.name,
                alt: file.name,
                url: URL.createObjectURL(file)
            }));
        })
    }
</script>


{#if filesetInput}
    <div class="flex gap-2 flex-wrap">
    {#each filesetInput as file}
        <div class="avatar">
            <div class="w-32 rounded">
                <img src={file.url} alt={file.alt} class="" />
            </div>
        </div>
    {/each}
    </div>
{/if}