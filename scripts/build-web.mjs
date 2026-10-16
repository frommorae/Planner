// Builds the website and the Android app's web files into ./web
//   src/app.html            the planner (same file that runs as the Claude artifact)
//   public/                 icons + manifest, copied as-is
//   config/planner.config.json   Supabase URL + publishable key (safe to be public)
import fs from 'node:fs';
import path from 'node:path';
import { execSync } from 'node:child_process';

const root = path.resolve(path.dirname(new URL(import.meta.url).pathname), '..');
const out = path.join(root, 'web');
fs.rmSync(out, { recursive: true, force: true });
fs.mkdirSync(path.join(out, 'vendor'), { recursive: true });
fs.cpSync(path.join(root, 'public'), out, { recursive: true });

let sha = 'local';
try { sha = execSync('git rev-parse --short HEAD', { cwd: root }).toString().trim(); } catch {}
const day = new Date().toISOString().slice(0, 10).replace(/-/g, '.');
const version = process.env.PLANNER_VERSION || `${day}-${sha}`;

const cfg = JSON.parse(fs.readFileSync(path.join(root, 'config/planner.config.json'), 'utf8'));
fs.writeFileSync(path.join(out, 'config.js'), `window.PLANNER_CONFIG = ${JSON.stringify({ ...cfg, version }, null, 2)};\n`);
fs.copyFileSync(path.join(root, 'node_modules/@supabase/supabase-js/dist/umd/supabase.js'), path.join(out, 'vendor/supabase.js'));

const app = fs.readFileSync(path.join(root, 'src/app.html'), 'utf8');
const split = app.indexOf('<div class="app">');
if (split < 0) throw new Error('src/app.html: could not find <div class="app">');
const head = `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#355C8C">
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" href="icons/favicon.png">
<link rel="apple-touch-icon" href="icons/apple-touch-icon.png">
<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}</style>
<script src="config.js"></script>
<script src="vendor/supabase.js"></script>
`;
const sw = `<script>
if ('serviceWorker' in navigator && !(window.Capacitor && window.Capacitor.isNativePlatform && window.Capacitor.isNativePlatform())) {
  window.addEventListener('load', () => navigator.serviceWorker.register('sw.js').catch(() => {}));
}
</script>`;
fs.writeFileSync(path.join(out, 'index.html'), head + app.slice(0, split) + '</head>\n<body>\n' + app.slice(split) + '\n' + sw + '\n</body>\n</html>\n');

const shell = ['./', 'index.html', 'config.js', 'vendor/supabase.js', 'manifest.webmanifest',
  'icons/icon-192.png', 'icons/icon-512.png', 'icons/favicon.png'];
fs.writeFileSync(path.join(out, 'sw.js'), `// Offline support for the website. Version ${version}
const CACHE = 'planner-${version}';
const SHELL = ${JSON.stringify(shell)};
self.addEventListener('install', e => { e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)).then(() => self.skipWaiting())); });
self.addEventListener('activate', e => { e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k.startsWith('planner-') && k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim())); });
self.addEventListener('fetch', e => {
  const req = e.request, url = new URL(req.url);
  if (req.method !== 'GET') return;
  if (url.origin === location.origin) {
    if (url.pathname.includes('/mcat/')) return; // Morae MCAT is its own page; leave it alone
    if (req.mode === 'navigate') { // newest page when online, saved page when offline
      e.respondWith(fetch(req).then(r => { const copy = r.clone(); caches.open(CACHE).then(c => c.put('index.html', copy)); return r; }).catch(() => caches.match('index.html')));
      return;
    }
    e.respondWith(caches.match(req).then(hit => hit || fetch(req).then(r => { const copy = r.clone(); caches.open(CACHE).then(c => c.put(req, copy)); return r; })));
    return;
  }
  if (/fonts\\.(googleapis|gstatic)\\.com$/.test(url.hostname)) { // keep fonts for offline use
    e.respondWith(caches.open(CACHE).then(c => c.match(req).then(hit => hit || fetch(req).then(r => { c.put(req, r.clone()); return r; }))));
  }
});
`);
console.log('Built web/ version', version);
