# Morae pets · art export (batch 1 + 2: geometric, pixel and isometric)

Drawing code and data for the optional study pets. Designed and coded with Claude (Anthropic) for Morae; all rights belong to the Morae project owner.

- `morae-pets.js`: `window.MoraePets.svg({ pet, stage, state, colour, items, island, weather, animate, frame })` returns an SVG string; `anchors()` gives item anchor points. No network, fonts or images.
- `pets.json`, `items.json`, `events.json`: roster, wardrobe and event sets.
- `preview.html`: every pet × stage × state, plus 32 px stills on four backgrounds.
- Icons are not kept here; the app draws head shots with `frame: 'icon'`. The full icon set is in the designer’s export.

Not wired into Morae MCAT yet (release 1 is being built). Pets are optional: off until a student turns them on.
