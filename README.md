# Morae Planner

A study planner and focus timer, built for MCAT prep: plan tomorrow on a 10-minute time-box grid, run a focus timer against the plan, then review plan vs actual and write one line about the day.

| | |
|---|---|
| **Website** | https://frommorae.github.io/Planner/ |
| **Morae MCAT (free beta)** | https://frommorae.github.io/Planner/mcat/ |
| **Android app (APK)** | [Latest beta release](https://github.com/frommorae/Planner/releases/latest) |
| **Setup guide** | [docs/SETUP.md](docs/SETUP.md) |
| **Feedback** | [FEEDBACK.md](FEEDBACK.md) |

## How it is built
- `src/app.html` is the whole app: one HTML file with its own CSS and JavaScript. The same file runs as the Claude artifact.
- `scripts/build-web.mjs` turns it into the website in `web/` (adds offline support, icons and the sync library).
- `android/` is a [Capacitor](https://capacitorjs.com) project that wraps the website as an Android app, with real notifications and keep-screen-on.
- `public/mcat/index.html` is Morae MCAT, an MCAT study planner (plan builder, practice and error logs, full lengths, content map). For now its data stays in each visitor's browser; sign-in sync with the planner account comes next.
- Sync between devices uses [Supabase](https://supabase.com). The table and its privacy rules are in `supabase/schema.sql`. The key in `config/planner.config.json` is the *publishable* key: it is designed to be public, and the privacy rules keep each person's data private.
- GitHub Actions rebuild the website on every change. A new APK is built every Sunday if the app changed (or on demand: Actions → Android APK → Run workflow, or a commit message containing `[apk]`). The Android app shows a "new version is ready" banner with a download button.

## Version 2 ideas
See the project backlog: Play Store release, Google Calendar import/export, a Chrome extension for site time, auto-start at planned blocks, accountability summaries, an optional AI weekly review, and an optional pet mode.

## Privacy and contact
- Privacy policy (draft): `public/privacy.html`, published at https://frommorae.github.io/Planner/privacy.html
- The in-app contact form (Settings → Contact & feedback) sends messages through [Web3Forms](https://web3forms.com). Put the access key in `config/planner.config.json` as `contactKey`. Like the Supabase key, it is safe to be public: it can only send messages to the owner's inbox.

## License
Source available, all rights reserved. You may read the code, but you may not copy, redistribute, or publish it (or apps built from it) without written permission.
