'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "0b1cd957febc1f5c5d6c90ac4ab2017c",
"assets/AssetManifest.bin.json": "f6647eb6d8b751d973029917e4c163a6",
"assets/AssetManifest.json": "e9d6a78961e043f9e2391584ac26d16f",
"assets/assets/background.webp": "2de1bf5b9cae8e5bdfa100cc04eed943",
"assets/assets/categ1.png": "69d9795db34c0d2beab492366b1ca501",
"assets/assets/categ2.png": "3a3d296f06d0ecbddb72d23646d3bf1d",
"assets/assets/categ3.png": "968d97146aaf490ebbbff9c770f720a7",
"assets/assets/categ4.png": "f54243853c04cd6f1b4df92658c68dbd",
"assets/assets/categ5.png": "11a77d70580c7d2d18df816a527352bc",
"assets/assets/DelaGothicOne-Regular.ttf": "0127db5944cef9f92135d2971367e803",
"assets/assets/role_pics/alla.png": "8c9691a9a475ec5d00328ea693498ddf",
"assets/assets/role_pics/blonde.png": "af64f8698f183ba0a760cca79df72b04",
"assets/assets/role_pics/bomber.png": "66027322a12eb1f351bfb7efada63c67",
"assets/assets/role_pics/harry.png": "6b2544b78fa8a4b4e037a84dee8abd10",
"assets/assets/role_pics/jack.png": "05f7976ae30421309496f8f17c2595de",
"assets/assets/role_pics/lana.png": "e50970a4b0da1cd2f7d298dbc3755aa3",
"assets/assets/role_pics/piggy.png": "9fe40b54d48b698762d073c1c685ab03",
"assets/assets/role_pics/pirat.png": "e2ba3c4bf7f7d80b7cf911d700c38fbd",
"assets/assets/role_pics/rock.png": "df6d24ab9466adfec529d8b3d8f771d4",
"assets/assets/role_pics/ryan.png": "dfc41d31f14131b11d4f35cf05ffa67d",
"assets/assets/role_pics/sherlok.png": "4ec890c839b4a38f14a09a166f104c9f",
"assets/assets/role_pics/swift.png": "9a4f2cce7a9b5b8483cb81ef5a84dfd9",
"assets/assets/role_pics/tatum.png": "9be2584c7c7245a0a56a501e36552467",
"assets/assets/role_pics/thatcher.png": "d4229f9876411a2dd6208307946b18e0",
"assets/assets/role_pics/tyler.png": "5894aac8825c8978563b7df1fd014153",
"assets/assets/role_pics/viking.png": "26598ba1b1d3e352dea838e476de973e",
"assets/assets/role_pics/zombie.png": "3765c1b67f8ca645f42feee73d44219b",
"assets/assets/words_categ/all_in.txt": "6a8b4d125775790d3ae0040656fa5908",
"assets/assets/words_categ/celeb.txt": "9d2cb29cf26a2c7116c74bbd6d9002d2",
"assets/assets/words_categ/countries.txt": "eed67d77461d4a92ba788e0b4d72043c",
"assets/assets/words_categ/locations.txt": "62cbe964e3201b31875d43798b4fa7ae",
"assets/assets/words_categ/movies.txt": "272b73ce2993fad3c63b6e38fef6471c",
"assets/FontManifest.json": "6c4c16438ddc17d49fa9de14b8b5f68b",
"assets/fonts/MaterialIcons-Regular.otf": "fda6bd1394f7f43aaf5b584bed6a1e6a",
"assets/NOTICES": "50c93562edcd11c5dde8430373e910c3",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "f3d89ad98dd12ffe1c0dcbbbdcb81225",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "5e0f09321bdc70c77609948c8640b7bc",
"/": "5e0f09321bdc70c77609948c8640b7bc",
"main.dart.js": "91235b468f64510af38e31e46fa16b46",
"manifest.json": "845eb4d2f3d54321747420d3af455616",
"version.json": "16c968fafaa6b5ed1f5ccce82ac2b48f"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
