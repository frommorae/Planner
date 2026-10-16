# Pet & item design brief

A brief for an illustrator or animator making pets, accessories and colour themes for the planner. Send this file as-is; the parts marked **Morae fills in** are filled in before it goes out.

---

## 1. The app in one paragraph
A calm study and work planner: you plan your day on a time-box grid, run a focus timer, and write a short review at night. An optional **pet** lives in the corner of the app and on the full-screen timer. It grows when you keep your plans and gets a little "cold" when you skip days. It should feel encouraging, never guilt-tripping, and never distract from studying.

## 2. Look and feel
- **Mood:** soft, friendly and quiet. Think "a companion on your desk", not a game mascot.
- **Shapes:** simple and rounded, readable at small size. The pet must still be recognizable at **32 × 32 px** (app header) and look good at **~280 × 280 px** (full-screen timer).
- **Colours:** muted pastels with one darker outline colour. The app's main colour is ink blue `#355C8C`; category colours are pastel (pink, mint, lavender, butter, sky).
- **Backgrounds:** transparent. Every pet must work on both a light background (`#F2F4F7`) and a dark one (`#13161B`). Test on both before delivering.
- **Avoid:** text inside artwork, tiny details that disappear at 32 px, drop shadows baked into the art, anything that resembles an existing character or brand.

## 3. What to make for each pet

### 3a. Growth stages
| Stage | When | Notes |
|---|---|---|
| 1 Baby | Start | Smallest, simplest |
| 2 Young | After a good week | Slightly bigger, more detail |
| 3 Grown | After several good weeks | Final look |

All stages sit on the **same canvas, centred on the same ground line**, so swapping stages doesn't make the pet jump.

### 3b. States (animated, looping) for every stage
| State | When the app shows it | Feeling |
|---|---|---|
| `idle` | App open, no timer running | Calm breathing or blinking |
| `focus` | Focus timer running | Concentrating: reading, working, still |
| `happy` | A task or session just finished | Small bounce or smile, 2–3 s, then back to idle |
| `rest` | On a break, or late at night | Sleeping or stretching |
| `cold` | Several weak days in a row | A little sad or shivery, **still cute, not upsetting** |
| `celebrate` | Grew a stage or hit a streak | Bigger moment, 3–4 s, plays once |

That is 3 stages × 6 states = **18 animations per pet**. To keep the first pet affordable, the minimum is **stage 2 only × 6 states**, with the other stages added later.

### 3c. Static images per pet
- A still pose per stage for the pet picker (same canvas).
- An app-icon-style head shot, 512 × 512, on a transparent background.

## 4. Items and accessories
- Items are things the pet can wear or hold: hats, scarves, glasses, a book, a mug, a desk lamp.
- Each item is delivered as a **separate transparent layer** that sits on top of the pet. It is never baked into the pet art.
- Every pet has the same **anchor points** marked on each stage and state: `head`, `face`, `neck`, `back`, `hand`. Mark them as small dots on a guide layer, or as a list of x/y coordinates on the 512 × 512 canvas.
- If an anchor moves during an animation (for example the head bobs), the item has to move with it. The easiest way: animate items in the same file as the pet, on their own named layer that can be switched on or off.
- An item needs a version for each stage if the pet's size changes between stages.

## 5. File formats
In order of preference:

1. **Lottie (`.json`)**, exported from After Effects with Bodymovin, or made in a Lottie tool. Small files, crisp at any size, layers can be switched on and off. Keep each file under ~150 KB, and don't use effects Lottie can't play (no expressions, no raster images inside).
2. **Layered SVG plus an animation description.** Fine for simple loops; Claude can animate in code from the layers.
3. **PNG sprite sheets** (fallback). Frames on a grid, transparent, 512 × 512 per frame, 12 frames per second, delivered at that size (the app scales down). Name the sheet with its frame count.

Always include:
- **Source files** (After Effects, Figma, Illustrator, Procreate or similar) with named layers.
- A **preview GIF or MP4** of every animation on light and on dark backgrounds.
- Loops that are **seamless** (the last frame flows into the first).

## 6. Naming
All lowercase, hyphens inside names, underscores between parts:

```
cat_stage2_idle.json
cat_stage2_focus.json
cat_stage1_still.png
cat_icon.png
item_beret_stage2.svg
theme_sakura.json
```

## 7. Colour themes (optional, separate quote)
A theme is a set of colours, not artwork. For each theme, give **light and dark** values for:
`paper` (page background), `sheet` (card background), `ink` (main text), `ink-2` (secondary text), `rule` (lines), `accent` (buttons and highlights), `accent-soft` (light accent background), plus 6 category pastels.
Text must stay readable: at least 4.5 : 1 contrast for `ink` on `sheet`, and 3 : 1 for `accent` on `sheet`.

## 8. Rights and ownership
- All delivered work is commissioned for this app. The designer **assigns full commercial rights** to Morae: use in the app, website, store listings, marketing and videos, the right to modify, and the right to sell as paid content.
- The work must be original. Tell us if any stock assets, fonts or AI tools were used, and which ones.
- The designer may show the work in their portfolio after it is released, with credit. Credit in the app's About page is offered by default.

## 9. Process
1. Rough sketches of 2–3 directions for the first pet (stage 2, idle).
2. Morae picks one; it is tested in the app at 32 px and full size.
3. Finished first pet (6 states) → feedback round → fixes.
4. Remaining stages, items and other pets, in batches.

Deadlines, price and number of revision rounds are agreed per batch in writing before work starts.

---

## Morae fills in before sending
- **Pets:** which ones, in order. The cat comes first (it's the free pet), then the premium pets.
- **For each pet:** a name, 2–3 personality words (for example "sleepy, curious, proud") and any reference photos or moods you like.
- **First batch of items:** 5–8 ideas.
- **Themes wanted:** names and a mood word or reference image each.
- **Budget and timeline** for the first batch.
- **Contact:** how the designer should send files (Google Drive or Dropbox link, not email attachments).

## What Claude needs back to build it in
- The files above, named as in section 6, in one shared folder.
- The anchor point list, if the items aren't animated inside the pet files.
- The preview GIFs, so the in-app version can be checked against what the designer intended.
