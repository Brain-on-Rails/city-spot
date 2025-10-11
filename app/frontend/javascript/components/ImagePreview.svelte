
<script>
    import PhotoSwipeLightbox from "photoswipe/lightbox";
    import PhotoSwipe from "photoswipe";
    import {onMount, onDestroy} from 'svelte';
    import 'photoswipe/style.css';

    let {
        input,
        previewContainer,
    } = $props();

    let images = $state([]);
    let lightbox;


    onMount(() => {
        listenToInputChanges();
    })

    function openLightbox(index) {
        if (!images.length) return;
        lightbox = new PhotoSwipeLightbox({
            dataSource: images,
            pswpModule: PhotoSwipe,
        })
        lightbox.init();
        lightbox.loadAndOpen(index);
    }

    function listenToInputChanges() {
        input.addEventListener('change', (event) => {
            if (!event.target.files) return;
            images = [];
            const inputFiles = Array.from(event.target.files)
            inputFiles.forEach(loadImage)
        })
    }

    function loadImage(inputFile) {
        const src = URL.createObjectURL(inputFile);
        const img = new Image();
        img.onload = () => {
            images.push({
                src,
                width: img.width,
                height: img.height,
                alt: inputFile.name,
            })
        }
        img.src = src;
    }
</script>

<div class="grid grid-cols-[repeat(auto-fit,minmax(100px,1fr))] gap-4 justify-start">
    {#each images as image, i}
        <button type="button" class="w-full h-full bg-gray-200" onclick={() => openLightbox(i)}>
            <img src={image.src} alt={image.name} title={image.name} class="cursor-pointer w-full object-cover" />
        </button>
    {/each}
</div>