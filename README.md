# Offline Demo App

This is a simple Ruby on Rails app showing how a service worker can be used to cache pages and display them offline using [Google Workbox](https://developer.chrome.com/docs/workbox). It has a default offline fallback for pages that are not cached and for routes not annotated with `no_fallback`.

View the deployed [offline demo app](https://offline-demo-app.onrender.com/) (may take a little time to spin up).

To avoid hard coded static URL paths in the service worker, routes are annotated with either `defaults: { offline_cache: true }`, `defaults: { warm_cache: true }` or `defaults: { no_fallback: true }`. This is a somewhat dirty approach since it means that controller params have `offline_cache`, `warm_cache` and `no_fallback` keys appended.

Pages that are warm cached are cached as soon as the service worker is installed so even if a user never accesses a page they will be able to view it offline.

To cache dynamic paths you can use regular expressions or check what a [URL path starts with](https://developer.chrome.com/docs/workbox/modules/workbox-strategies#network_first_network_falling_back_to_cache) in the `service_worker.js.erb` file.

**Note** Service workers are complicated so please use this demo just for ideas. A real life example of a sophisticated offline capable Rails app is the [Rails World Conference App](https://github.com/TelosLabs/rails-world).

Handy references include:
* https://alicia-paz.medium.com/make-your-rails-app-work-offline-part-1-pwa-setup-3abff8666194
* https://alicia-paz.medium.com/make-your-rails-app-work-offline-part-2-caching-assets-and-adding-an-offline-fallback-334729ade904
* https://alicia-paz.medium.com/make-your-rails-app-work-offline-part-3-crud-actions-with-indexeddb-and-stimulus-ad669fe0141c
* https://dev.to/mikerogers0/how-to-make-rails-work-offline-pwa-p05
* https://blog.codeminer42.com/everything-you-need-to-ace-pwas/
* https://blog.codeminer42.com/everything-you-need-to-ace-pwas-in-rails-part-ii/
* https://blog.railsforgedev.com/how-to-build-a-progressive-web-app-with-ruby-on-rails-8-a-complete-guide
