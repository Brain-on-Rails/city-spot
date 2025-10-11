<script>
    import { onMount } from 'svelte';
    // import lightGallery from 'lightgallery';
    // import lgZoom from 'lightgallery/plugins/zoom';
    // import lgThumbnail from 'lightgallery/plugins/thumbnail';

    onMount(() => {

    })

    function handleFileInput(event) {
        const files = event.target.files;
        console.log(files);
    }
</script>


<label class="btn btn-success btn-xl">
    +
    <input type="file" onchange="{handleFileInput}" style="display:none;" multiple>
</label>
