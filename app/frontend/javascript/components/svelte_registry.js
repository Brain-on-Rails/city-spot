import {mount, unmount} from "svelte";

const registry = new Map();

export function registerComponent(selector, Component, props = {}) {
  registry.set(selector, { Component, props, instance: null });
  mountComponent(selector);
}

initTurboLifecycles();

function initTurboLifecycles() {
    document.addEventListener('turbo:load', () => {
        for (const [selector, entry] of registry) {
            if (!entry.instance) {
                mountComponent(selector)
            }
        }
    })

    document.addEventListener('turbo:before-cache', () => {
        for (const [selector, entry] of registry) {
            if (entry.instance) {
                unmount(entry.instance)
                entry.instance = null
            }
        }
    })
}

function mountComponent(selector) {
    const entry = registry.get(selector);
    if (isEntryNotRegistered(selector)) return;
    if (isEntryAlreadyMounted(selector)) return;

    const target = document.querySelector(selector);
    if (target)
        entry.instance = mount(entry.Component, { target, props: entry.props });
}

function isEntryRegistered(selector) { return registry.has(selector); }
function isEntryNotRegistered(selector) { return !registry.has(selector); }
function isEntryAlreadyMounted(selector) { return registry.get(selector)?.instance; }