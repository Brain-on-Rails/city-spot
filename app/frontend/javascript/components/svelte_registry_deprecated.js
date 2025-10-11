import {mount, unmount} from "svelte";

const registry = new Map();

export function registerComponent(selector, Component) {
    registry.set(selector, {Component, instance: null});
    mountComponent(selector);
}

initTurboLifecycles();

function initTurboLifecycles() {
    // document.addEventListener('turbo:render', scanAndMountAllComponents)
    document.addEventListener('turbo:load', scanAndMountAllComponents)

    document.addEventListener('turbo:before-cache', () => {
        for (const [selector, entry] of registry) {
            if (entry.instance) {
                unmount(entry.instance)
                entry.instance = null
            }
        }
    })
}

function scanAndMountAllComponents() {
    for (const [selector, entry] of registry) {
        mountComponent(selector)
    }
}

function mountComponent(selector) {
    const entry = registry.get(selector);
    if (isEntryNotRegistered(selector)) return;
    if (isEntryAlreadyMounted(selector)) return;

    const target = document.querySelector(selector);

    if (target) {
        const props = Object.fromEntries(
            Object.entries(target.dataset).map(([key, value]) => [key, parseDataValue(value)])
        )
        entry.instance = mount(entry.Component, {target, props: props});
        if (import.meta.env.DEV) console.log(`Component mounted: ${selector}`);
    }
}

function isEntryRegistered(selector) {
    return registry.has(selector);
}

function isEntryNotRegistered(selector) {
    return !registry.has(selector);
}

function isEntryAlreadyMounted(selector) {
    return registry.get(selector)?.instance;
}

function parseDataValue(value) {
    if (value === "true") return true;
    if (value === "false") return false;
    if (/^-?\d+$/.test(value)) return parseInt(value, 10);
    if (!isNaN(value)) return parseFloat(value);
    return value;
}