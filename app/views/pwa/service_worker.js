/* global self, clients, importScripts, workbox */

importScripts(
  "https://storage.googleapis.com/workbox-cdn/releases/7.3.0/workbox-sw.js"
);

// workbox sw chrome console logging is on by default for localhost
// to turn on for other hosts uncomment the code below
// see https://developer.chrome.com/docs/workbox/troubleshooting-and-logging#without_a_bundler
// workbox.setConfig({
//   debug: true // or add .erb to the filename and use <%= !Rails.env.production? %>
// });

const updateServiceWorker = '1' // Increment this value if offline fallback page changes so it gets re-cached
const cacheExpirationInSeconds = 1 * 60;
const SW_IMAGE_CACHE_VERSION = 'v1';

const { CacheFirst, NetworkFirst, NetworkOnly } = workbox.strategies;
const { registerRoute } = workbox.routing;
const { ExpirationPlugin } = workbox.expiration;
const networkOnlyUrls = ['/online-only'];

self.skipWaiting();

// For assets (scripts, styles and images), we use cache first
registerRoute(
  ({ request }) => request.destination === "script" ||
    request.destination === "style",
  new CacheFirst({
    cacheName: 'assets-styles-and-scripts',
    plugins: [
      new ExpirationPlugin({
        maxEntries: 100
      })
    ]
  })
)
registerRoute(
  ({ request }) => request.destination === "image",
  new CacheFirst({
    cacheName: `assets-images-${SW_IMAGE_CACHE_VERSION}`,
    plugins: [
      new ExpirationPlugin({
        maxEntries: 100
      })
    ]
  })
)

registerRoute(
  ({ request, url }) => networkOnlyUrls.includes(url.pathname),
  new NetworkOnly()
)

// For pages, network first
const documentsStrategyOptions = {
  cacheName: 'documents',
  matchOptions: { ignoreVary: true },
  plugins: [
    new ExpirationPlugin({
      maxEntries: 100
    })
  ]
}

// see https://developer.chrome.com/docs/workbox/modules/workbox-routing
registerRoute(
  ({ request, url }) => request.destination === 'document' ||
    request.destination === '',
  new NetworkFirst(documentsStrategyOptions)
)

self.addEventListener('message', (event) => {
  if (event.data === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

// Warm runtime cache so urls are cached before they are visited
const { warmStrategyCache } = workbox.recipes;
const urls = ['/', '/show'];
const strategy = new NetworkFirst(documentsStrategyOptions);
warmStrategyCache({ urls, strategy });

// Warm runtime cache with an offline URL
const offlineUrls = ['/offline.html'];
const offlineStrategy = new NetworkFirst();
warmStrategyCache({ urls: offlineUrls, strategy: offlineStrategy });

// Trigger a 'catch' handler when any of the other routes fail to generate a response
const { setCatchHandler } = workbox.routing;
setCatchHandler(async ({ event }) => {
  switch (event.request.destination) {
    case '':
    case 'document':
      return offlineStrategy.handle({ event, request: offlineUrls[0] })
    default:
      return Response.error()
  }
})

