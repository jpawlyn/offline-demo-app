# Offline Demo App

This is a simple Ruby on Rails app showing how a service worker can be used to cache pages and display them offline using [Google Workbox](https://developer.chrome.com/docs/workbox). It has a default offline fallback for pages that are not cached and for routes not annotated with `sw_no_fallback`.

View the deployed [offline demo app](https://offline-demo-app.onrender.com/) (may take a little time to spin up).

## Design

To avoid hard coded static URL paths in the service worker, routes are annotated with either `defaults: { sw_offline_cache: true }`, `defaults: { sw_warm_cache: true }` or `defaults: { sw_no_fallback: true }`. This is a somewhat dirty approach since it means that controller params have `sw_offline_cache`, `sw_warm_cache` and `sw_no_fallback` keys inserted.

Pages that are warm cached are cached as soon as the service worker is installed so even if a user never accesses a page they will be able to view it offline.

## Testing

To run all the tests run the following command from the terminal:
```sh
bin/rspec -t run_first && bin/rspec
```

By default the tests run headless but to see them run in a browser, prefix both calls to `bin/rspec` with `HEADLESS=false`.

By default `bin/rspec` excludes tests tagged with `run_first`.

In order to test the service worker when offline, the selenium-webdriver gem has been [monkey patched](https://github.com/jpawlyn/offline-demo-app/blob/main/spec/support/devtools_monkey_patch.rb). This was needed since the standard way of setting network conditions only applies to requests made directly from the browser to the server and not via a service worker.

The [cuprite chrome driver](https://github.com/rubycdp/cuprite) does not support service workers yet but this [could change](https://github.com/rubycdp/ferrum/pull/391).

To go offline and online in system tests see [network_conditions.rb](https://github.com/jpawlyn/offline-demo-app/blob/main/spec/support/network_conditions.rb).

System tests should only run once the service worker has activated. To enforce this the [service worker state is checked](https://github.com/jpawlyn/offline-demo-app/blob/main/spec/support/selenium_setup.rb) in a before hook and only when the state is activated do tests run.

## Suggestions for handling other scenarios

To cache dynamic paths and paths with query parameters (eg pagination) you can use regular expressions or check what a [URL path starts with](https://developer.chrome.com/docs/workbox/modules/workbox-strategies#network_first_network_falling_back_to_cache) in the `service_worker.js.erb` file.


## References

Service workers are complicated so please use this demo just for ideas. A real life example of a sophisticated offline capable Rails app is the [Rails World Conference App](https://github.com/TelosLabs/rails-world).

* [Make your Rails app work offline. Part 1: PWA setup](https://alicia-paz.medium.com/make-your-rails-app-work-offline-part-1-pwa-setup-3abff8666194)
* [Everything You Need to Ace PWAs in Rails](https://blog.codeminer42.com/everything-you-need-to-ace-pwas/)
