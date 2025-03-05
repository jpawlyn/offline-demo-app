/* global self, clients, importScripts, workbox */

importScripts(
  "https://storage.googleapis.com/workbox-cdn/releases/7.3.0/workbox-sw.js"
);

const cacheExpirationInSeconds = 1 * 60;
const SW_IMAGE_CACHE_VERSION = 'v1';

const { CacheFirst, NetworkFirst } = workbox.strategies;
const { registerRoute } = workbox.routing;
const { ExpirationPlugin } = workbox.expiration;

self.skipWaiting();

// For assets (scripts, styles and images), we use cache first
registerRoute(
  ({ request }) => request.destination === "script" ||
    request.destination === "style",
  new CacheFirst({
    cacheName: 'assets-styles-and-scripts',
    plugins: [
      new ExpirationPlugin({
        maxEntries: 20
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
        maxEntries: 20
      })
    ]
  })
)

// For pages, network first
const documentsStrategyOptions = {
  cacheName: 'documents',
  plugins: [
    new ExpirationPlugin({
      maxAgeSeconds: cacheExpirationInSeconds
    })
  ]
}

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

