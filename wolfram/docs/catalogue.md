# Wolfram File Catalogue

Files identified across `/Users/matthew/TransferM4` and `/Users/matthew/Dropbox`.
Catalogued 2026-07-02.

## Publish as downloads (`wolfram/downloads/`)

| File | Source path | Size | Description | Action |
|------|------------|------|-------------|--------|
| `PrimFairflow_2014_10_27_022.cdf` | TransferM4/Downloads | 211 KB | Interactive Prim's algorithm teaching demo | Copy to downloads/ + offer via download link |
| `FibonacciTrees.cdf` | Dropbox/git/Consultancy | 14 KB | Fibonacci spiral / Golden ratio planting interactive | Copy to downloads/ |
| `Jitterbug2.cdf` | TransferM4/Documents | 14 KB | Jitterbug polyhedron (Buckminster Fuller) interactive | Copy to downloads/ |
| `NetworkDesign_10_22_03.cdf` | TransferM4/Documents | 482 KB | Network/graph design tool (graph theory teaching) | Copy to downloads/ |
| `PowerTriangleMac.nb` | Dropbox/Teaching | 1.6 MB | Triangle of Power notebook — polished version | Copy to downloads/ (Git LFS) |
| `YFrontC.nb` | TransferM4/Downloads | 1.2 MB | Triangle of Power notebook — variant/earlier version | Copy to downloads/ (Git LFS) — confirm with Matthew which to feature |

## Needs conversion to GIF/MP4 for web display

These CDF files contain animations or interactives that cannot be embedded in a
browser anymore. Convert via Mathematica / Wolfram Desktop before publishing.

| File | Notes |
|------|-------|
| `PrimFairflow_2014_10_27_022.cdf` | Export a walkthrough GIF showing the algorithm step by step |
| `FibonacciTrees.cdf` | Export a rotating/animated GIF of the spiral |
| `Jitterbug2.cdf` | Export a rotation animation GIF |

For Wolfram Cloud embedding (interactive), open each `.nb` / `.cdf` source in
Wolfram Desktop, publish to Wolfram Cloud (File → Publish to Cloud), and add
the cloud URL to the relevant post via the `[wolfram_embed]` shortcode.

See `wolfram/README.md` for step-by-step instructions.

## Source only — do not publish

| File | Reason |
|------|--------|
| `TeachingLearningPrimFairflow_2014_10_27_01.nb` | Incomplete helper/scratch file |
| `Fairtlough_Pollard.nb` | Meeting notes with embedded content — extract spiral code if needed |
| `GraphTheoryReportStylesheet.nb` | Stylesheet pointer only, no content |
| `YFrontCtester.nb` | Duplicate of YFrontC.nb used for testing |
| `Octonions.nb` / `Octonions.cdf` | Niche abstract algebra — out of current site scope |
| `HopfFibrationOfTheThreeSphere.cdf` | Topology demo — out of current scope |
| `RotatingTheHopfFibration.cdf` | Topology demo — out of current scope |
| `GeneratingTheSurrealNumbers-author.nb` | Wolfram demo notebook, not Fairflow content |

## GIF files already on disk (existing web assets)

These GIFs were used on the original fairflow.co.uk/design site and are already
at known URLs referenced in the WordPress export. Recover them from:

- `/Users/matthew/TransferM4/matthew/Dropbox/Teaching/TeachingLearningPrimFairflow_2014_10_27_01.nb`
- `/Users/matthew/TransferM4/matthew/git_mac_files/TeachingLearningPrimFairflow_2014_10_27_0*.gif`

Copy GIF files to `wolfram/media/` and update WordPress post attachments.
