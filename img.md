# Royalty-Free Image Search

Search Pexels (and optionally Pixabay) for royalty-free images and build a clickable
picker page. Arguments: $ARGUMENTS

## Quick Start

If arguments are provided, treat them as the search query and run immediately with 12
images, any orientation, using whichever sources have a key configured.

## Step 0: Check the API Keys

Pexels is the baseline source. Pixabay is optional and only used if its key is present.

```bash
test -n "$PEXELS_API_KEY" && echo "pexels: yes" || echo "pexels: NO"
test -n "$PIXABAY_API_KEY" && echo "pixabay: yes" || echo "pixabay: no"
```

If `pexels: NO`, do NOT just print an error and stop. Onboard the user yourself, in
plain language, so they never have to touch a config file by hand:

1. Tell them: "You need a free Pexels API key. It takes about a minute and no coding.
   Open https://www.pexels.com/api/, sign up (free, no credit card), copy your key, and
   paste it here."
2. When they paste the key, offer to save it so this is a one-time step. With their
   agreement, append the line below to their shell profile (`~/.zshrc` if their shell is
   zsh, `~/.bashrc` if bash; check `$SHELL`):

   ```bash
   export PEXELS_API_KEY="THE_KEY_THEY_PASTED"
   ```

   Then confirm in one sentence what you did and that it will be remembered next time.
3. Use the key they just pasted for THIS session's API calls right away, so they see
   results now without restarting anything.

If they would rather not save it to their shell profile, offer to write it to a local
`.env` file instead (the included `.gitignore` already excludes `.env`), or to use it for
this one session only. Never echo the full key back to them and never commit it anywhere.

The same applies to Pixabay: if the user asks for illustrations or vectors and no
`PIXABAY_API_KEY` is set, walk them through https://pixabay.com/api/docs/ the same way.
Pixabay is always optional; never block on it.

## Step 1: Gather Requirements

If no arguments were given, ask the user the following questions and wait for their
answers before continuing. Plain text works in any tool. If your CLI has a structured
question UI (Claude Code's AskUserQuestion, Gemini CLI's ask_user), you may use it, but
do not depend on it.

- "What images do you need?" (comma-separate for multiple searches, e.g. "massage therapy, healthy food")
- Number per search: 8, 12, or 20
- Orientation: Any, Landscape, Portrait, Square
- Source, ONLY if `PIXABAY_API_KEY` is set: Pexels, Pixabay, or Both. If the Pixabay key
  is not set, skip this question and use Pexels.

## Step 2: Run the Searches

For EACH search term, query each chosen source.

Pexels:

```bash
curl -s "https://api.pexels.com/v1/search?query=QUERY&per_page=NUM&orientation=ORIENTATION" \
  -H "Authorization: $PEXELS_API_KEY" \
  > /tmp/pexels-LABEL.json
```

- Replace spaces in QUERY with `+`.
- Drop the `&orientation=` parameter entirely for "Any".
- Pexels orientation values: `landscape`, `portrait`, `square`.

Pixabay (only if chosen):

```bash
curl -s "https://pixabay.com/api/?key=$PIXABAY_API_KEY&q=QUERY&per_page=NUM&orientation=ORIENTATION&image_type=all&safesearch=true" \
  > /tmp/pixabay-LABEL.json
```

- URL-encode QUERY (spaces become `+`). Pixabay limits `q` to 100 characters.
- Pixabay orientation values are different: `horizontal` (landscape), `vertical`
  (portrait), or `all` (any/square). Map the user's choice accordingly; use `all` for
  Square or Any.
- `per_page` minimum is 3.

Use a short descriptive LABEL per term (e.g. `pexels-massage.json`,
`pixabay-massage.json`). After each call, sanity-check the file is valid JSON with
results. Pexels returns a `photos` array; Pixabay returns a `hits` array. If a response
has an `error` field or zero results, tell the user and let them adjust the term.

## Step 3: Build the Picker Page

Read each `/tmp/pexels-*.json` and `/tmp/pixabay-*.json` file directly and write a single
self-contained HTML file to `/tmp/pexels-results.html`. Do NOT use jq or shell JSON
parsing. Read the files and generate the markup yourself.

Requirements for the page:

1. One labelled section per search term. If both sources were used, label each card or
   sub-section with its source so credits and links stay correct.
2. Responsive grid of image cards with appropriate alt text.
3. Click a card to open the full image in a centered modal/lightbox. Click the backdrop
   or press Escape to close.
4. Each card shows a photographer/creator credit linking to their profile, plus a
   "View on [source]" link to the image's page. Crediting the creator and linking back
   is required by both Pexels and Pixabay API guidelines.
5. Each card has two buttons: "Download" (links to the high-res URL with a `download`
   attribute) and "Copy URL" (copies the full image URL via `navigator.clipboard`).
6. No emojis anywhere. Plain, clean styling with system fonts. No external CSS or JS
   frameworks; inline everything so the file works offline.

Field mapping per source:

Pexels (`photos[]`):
```
photographer        creator name
photographer_url    link to their Pexels profile
url                 link to the photo's page on Pexels
alt                 description text
src.medium          thumbnail (~400px)
src.large2x         modal + Download (high-res)
src.original        Copy URL (full original)
```

Pixabay (`hits[]`):
```
user                creator name
pageURL             link to the image's page on Pixabay (use for credit + "View on Pixabay")
tags                description text for alt
webformatURL        thumbnail (640px)
largeImageURL       modal, Download, and Copy URL (high-res)
```

## Step 4: Open and Review

Open the file with the platform-appropriate command:

- macOS: `open /tmp/pexels-results.html`
- Linux: `xdg-open /tmp/pexels-results.html`
- Windows: `start /tmp/pexels-results.html`

Then:

- Confirm the images loaded.
- Offer to refine with different terms.
- Offer to remove unwanted images and rebuild.

## API Reference

Pexels:
- Endpoint: `https://api.pexels.com/v1/search`
- Auth header: `Authorization: $PEXELS_API_KEY`
- Params: `query`, `per_page` (max 80), `orientation` (`landscape` | `portrait` | `square`)

Pixabay (optional):
- Endpoint: `https://pixabay.com/api/`
- Auth: `key=$PIXABAY_API_KEY` as a query parameter
- Params: `q` (max 100 chars), `per_page` (3-200), `orientation` (`horizontal` |
  `vertical` | `all`), `image_type` (`all` | `photo` | `illustration` | `vector`)

## Search Tips

- Be specific: "gut health supplements" beats "health".
- Add modifiers: "professional", "clinical", "lifestyle".
- To avoid people, search for objects or food directly.
- Run several searches for variety.
- Pixabay is the source to use when you want illustrations or vector graphics, not just
  photos.
