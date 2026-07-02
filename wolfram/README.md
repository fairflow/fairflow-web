# Wolfram Content for the Fairflow Website

## Background

The original site embedded interactive CDF (Computable Document Format) files
via a Wolfram browser plugin. That plugin was discontinued ~2019 and no longer
works in any modern browser.

## Strategy (2026)

| Original format | Web delivery method |
|----------------|---------------------|
| `.cdf` interactive demo | Export to **MP4** or **animated GIF** from Mathematica / Wolfram Desktop |
| `.nb` notebook (interactive) | Upload to **Wolfram Cloud** → embed via iframe |
| `.nb` notebook (static/document) | Render to **PDF** or **HTML** → offer as download |
| `.cdf` / `.nb` as download | Offer as download link (Git LFS in `wolfram/downloads/`) |

## Wolfram Cloud embedding

1. Open the notebook in Wolfram Desktop
2. **File → Publish to Cloud** (requires a free Wolfram account)
3. Set permissions: **Anyone can Interact**
4. Copy the cloud URL, e.g. `https://www.wolframcloud.com/obj/username/MyNotebook`
5. In WordPress, use a Custom HTML block:

```html
<div class="wolfram-embed">
  <script src="https://www.wolframcloud.com/obj/wolframnotebooks/embedder/WolframNotebookEmbedder.js"></script>
  <div id="wolfram-nb-1"></div>
  <script>
    WolframNotebookEmbedder.embed(
      'https://www.wolframcloud.com/obj/YOUR_USERNAME/YOUR_NOTEBOOK',
      document.getElementById('wolfram-nb-1'),
      { width: 800, height: 600 }
    );
  </script>
</div>
```

## Converting CDF to animated GIF (in Mathematica)

Open the `.cdf` or `.nb` source, then:

```mathematica
(* Export the Manipulate as an animation *)
Export["output.gif", Table[
  (* Replace YourManipulate with your actual expression *)
  YourManipulate /. param -> val,
  {val, range}
], "AnimationRepetitions" -> Infinity]
```

Or for MP4 (better quality):
```mathematica
Export["output.mp4", yourAnimationFrames, "FrameRate" -> 12]
```

## Files catalogued for the website

See `wolfram/docs/catalogue.md` for the full list of `.nb`/`.cdf` files
found across your repositories and Dropbox, with notes on which are
web-publishable.

## Downloads directory

Files in `wolfram/downloads/` are:
- Tracked in Git via **LFS** (large binary storage)
- Only files **intended for public download** should be here
- Do NOT place private notebooks, client work, or financial spreadsheets here

## Wolfram Player

Users who want to open `.cdf` / `.nb` files locally can download:
https://www.wolfram.com/player/
