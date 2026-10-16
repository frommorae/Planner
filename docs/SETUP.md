# Setup guide

You only do this once. Every step is clicking in a browser; no coding.

---

## Part 1 · Turn on the website (2 minutes, on your laptop)

GitHub only lets you change these two settings yourself.

**Make the repository public** (the code becomes visible; your planner data never is):
1. Open **https://github.com/frommorae/Planner** and click **Settings** (the tab with a gear, top right of the repo page).
2. Scroll to the very bottom, to **Danger Zone**. Click **Change visibility** → **Change to public**.
3. Click through the confirmation buttons (GitHub asks you to confirm a few times).

**Turn on GitHub Pages:**
4. Still in **Settings**, click **Pages** in the left menu.
5. Under **Build and deployment → Source**, choose **GitHub Actions**.

**Publish the site:**
6. Click the **Actions** tab (top of the repo page) → **Website** in the left list → **Run workflow** (right side) → green **Run workflow** button.
7. Wait about a minute until the run shows a green check. The site is live at
   **https://frommorae.github.io/Planner/**

On your laptop, Chrome shows an **Install** icon at the right end of the address bar. Click it to open the planner in its own window, like an app.

---

## Part 2 · Sync between phone and laptop (Supabase, about 10 minutes)

Supabase is a free online database. Your planner saves there when you are signed in, so the website and the Android app show the same plan.

1. Go to **https://supabase.com** and click **Start your project**. Choose **Continue with GitHub**.
2. Click **New project**.
   - **Name:** `study-planner`
   - **Database password:** click **Generate a password**. You won't need it for the planner; save it in your password manager anyway.
   - **Region:** pick **Canada (Central)** (or the closest one offered).
   - Click **Create new project** and wait about 2 minutes until the dashboard appears.
3. Create the planner's table:
   - Open **https://github.com/frommorae/Planner/blob/main/supabase/schema.sql** in another tab.
   - Click the **Copy raw file** icon (two overlapping squares, top right of the file).
   - In Supabase, click **SQL Editor** in the left sidebar, then **New query**.
   - Paste, then click **Run**. You should see *Success. No rows returned*.
4. Tell Supabase where the planner lives:
   - Left sidebar: **Authentication** → **URL Configuration**.
   - **Site URL:** `https://frommorae.github.io/Planner/` → **Save**.
5. (Optional, makes signing up faster) **Authentication** → **Sign In / Providers** → **Email** → turn off **Confirm email** → **Save**.
   If you leave it on, Supabase emails you a link to confirm your account the first time.
6. Copy the two values the planner needs:
   - Left sidebar: **Project Settings** (gear icon) → **Data API** (or **API**) → copy the **Project URL**. It looks like `https://abcdefghij.supabase.co`.
   - **Project Settings** → **API Keys** → copy the **Publishable key** (starts with `sb_publishable_`). If you only see older keys, copy the one labelled **anon public**.
   - ⚠️ Never share the **secret** or **service_role** key.
7. Paste both values to Claude in the chat. The publishable key is designed to be public, so this is safe. Claude adds them and the website and app update by themselves within a few minutes.

---

## Part 3 · Install the Android app

1. On your phone, open **https://github.com/frommorae/Planner/releases/latest**.
2. Under **Assets**, tap **study-planner-0.1.N.apk** (N is the build number). Chrome downloads it.
3. Tap the download notification, or open **Files → Downloads** and tap the file.
4. If Android says Chrome isn't allowed to install apps, tap **Settings**, turn on **Allow from this source**, and go back.
5. Tap **Install**. If Play Protect warns about an unknown app, tap **More details → Install anyway**. It's your own app; Play Protect warns about every app that isn't from the Play Store.
6. Open **Morae Planner** and allow notifications when it asks (it asks the first time you start a focus).
7. For timer alerts that arrive exactly on time: Android **Settings → Apps → Morae Planner → Alarms & reminders → Allow** (only some phones show this option).

**Updating:** the website updates by itself. A new APK is built once a week (Sunday morning) if anything changed. When one is ready, the app shows a banner with a **Download** button; install it the same way. It installs over the old one and keeps your data. Need it sooner? On GitHub open **Actions → Android APK → Run workflow**.

---

## Part 4 · Sign in and bring your data over

1. Open the website (or the app) → **Settings** → **Your data** → enter your email and a password (8 or more characters) → **Create account**. Next time, and on your other device, use **Sign in** with the same email and password.
2. To bring over what you entered in the Claude artifact:
   - In the artifact: **Settings → Your data → Export backup** and save the file.
   - On the website, **signed in**: **Settings → Your data → Import → Choose file** → pick that file → **Replace**.
   - It uploads to your account, and the app on your phone picks it up after you sign in there.
3. **Lock the door behind you (recommended):** once your own account works, go to Supabase → **Authentication** → **Sign In / Providers** and turn off **Allow new users to sign up** → **Save**. Strangers could never see your data anyway, but this stops anyone else from creating accounts on your project.

---

## Optional · Use your own web address (e.g. aio.yourname.com)

GitHub can only show the planner on a domain **you own**. `planner.com` belongs to someone else, which is why the DNS check fails.

1. Buy a domain from a registrar (Cloudflare, Porkbun or Namecheap, usually about $10–15 a year), for example `yourname.com`.
2. In the registrar's **DNS** settings, add a record:
   - **Type:** `CNAME` · **Name:** `aio` · **Target / Value:** `frommorae.github.io`
3. In GitHub: repo **Settings → Pages → Custom domain** → type `aio.yourname.com` → **Save**. The check can take from a few minutes to a few hours.
4. When it turns green, tick **Enforce HTTPS**.
5. Tell Claude the new address. Claude updates the app's settings, and you change the **Site URL** in Supabase (Authentication → URL Configuration) to the new address.

Until you own a domain, leave the Custom domain box **empty**, otherwise the github.io address stops working.

---

## Part 5 · Giving feedback
Open **https://github.com/frommorae/Planner/blob/main/FEEDBACK.md**, tap the pencil icon, write short lines, and tap **Commit changes**. Then tell Claude "read FEEDBACK.md".
Settings in the planner shows a version number at the bottom; mention it if something breaks.
