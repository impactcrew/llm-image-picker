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

If `pexels: NO`, do NOT ask the user to paste their key into this chat. API keys must
never be entered into an AI session: anything typed to the assistant is sent to the model
provider and may be logged. Instead, guide them through a secure one-time setup that
keeps the key on their own machine:

1. Tell them, in plain language: "You need a free Pexels API key. It takes about a minute
   and no coding. For your security, do not paste it here. Open
   https://www.pexels.com/api/, sign up (free, no credit card), and copy your key."
2. Point them to the included setup script, which prompts for the key with hidden input
   in their OWN terminal and saves it to their shell profile. They run it themselves
   (for example, in Claude Code they can type `! ./setup.sh`):

   ```bash
   ./setup.sh
   ```

   If they do not have the script, give them the manual alternative to run in their own
   terminal, not in this chat: add `export PEXELS_API_KEY="..."` to `~/.zshrc` (zsh) or
   `~/.bashrc` (bash), then open a new terminal.
3. Once done, have them run /img again, and re-run the Step 0 check.

If the user pastes a key into the chat anyway, do not store it or quietly use it. Tell
them it is now exposed in the session, recommend they rotate it at
https://www.pexels.com/api/, and point them back to the setup script.

The same applies to the optional Pixabay key (https://pixabay.com/api/docs/): never
accept it in chat; route through `setup.sh` or a manual export. Pixabay is always
optional; never block on it.

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
