# Offline Demo App

This is a simple Ruby on Rails app showing how a service worker can be used to cache pages and display them offline using [Google Workbox](https://developer.chrome.com/docs/workbox). It has a default offline fallback for pages that are not cached and for routes not annotated with `sw_no_fallback`.

View the deployed [offline demo app](https://offline-demo-app.onrender.com/) (may take a little time to spin up).

To avoid hard coded static URL paths in the service worker, routes are annotated with either `defaults: { sw_offline_cache: true }`, `defaults: { sw_warm_cache: true }` or `defaults: { sw_no_fallback: true }`. This is a somewhat dirty approach since it means that controller params have `sw_offline_cache`, `sw_warm_cache` and `sw_no_fallback` keys inserted.

Pages that are warm cached are cached as soon as the service worker is installed so even if a user never accesses a page they will be able to view it offline.

To cache dynamic paths you can use regular expressions or check what a [URL path starts with](https://developer.chrome.com/docs/workbox/modules/workbox-strategies#network_first_network_falling_back_to_cache) in the `service_worker.js.erb` file.

**Note** Service workers are complicated so please use this demo just for ideas. A real life example of a sophisticated offline capable Rails app is the [Rails World Conference App](https://github.com/TelosLabs/rails-world).

Handy references include:
* [Make your Rails app work offline. Part 1: PWA setup](https://alicia-paz.medium.com/make-your-rails-app-work-offline-part-1-pwa-setup-3abff8666194)
* [Everything You Need to Ace PWAs in Rails](https://blog.codeminer42.com/everything-you-need-to-ace-pwas/)
