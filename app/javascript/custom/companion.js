if (navigator.serviceWorker) {
  navigator.serviceWorker.register("/service-worker.js", { scope: "/" })
    .then(() => navigator.serviceWorker.ready)
    .then(() => console.debug("[Companion]", "Service worker registered!"));
}
