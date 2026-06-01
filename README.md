# /img - Royalty-Free Image Search for AI Coding Tools

A slash command that searches [Pexels](https://www.pexels.com/) (and optionally
[Pixabay](https://pixabay.com/)) for royalty-free images and builds a clickable picker
page: a grid of results, click to enlarge, download and copy-URL buttons, and creator
credits.

One file plus your own free API key. Works in any AI coding tool: Claude Code, Cursor,
Aider, Gemini CLI, Codex, and others.

## Setup

### 1. Install the command

Pick one:

- **In your AI tool:** paste this into the chat. Your assistant grabs the file and installs
  it wherever your tool keeps commands. (It follows the link you give it, so only do this
  with sources you trust.)

  ```
  Install the /img command from https://github.com/impactcrew/llm-image-picker
  ```

- **In a terminal:** run this one line. It works from any folder, no clone needed. The
  path shown is Claude Code's; for another tool, swap in that tool's commands folder.

  ```bash
  mkdir -p ~/.claude/commands && curl -fsSL https://raw.githubusercontent.com/impactcrew/llm-image-picker/main/img.md -o ~/.claude/commands/img.md
  ```

### 2. Add a free API key

1. **Get a free Pexels API key:** go to [pexels.com/api](https://www.pexels.com/api/),
   sign up (free, no credit card), and copy your key.
2. **Run `/img`.** The first time you run it, it creates a file called
   `~/.config/img/keys.env`, opens it, and asks you to paste your key on the
   `PEXELS_API_KEY` line. Save it, and you're set for every project.

Paste your key into that file, never into the AI chat.

Optional, for illustrations and vector graphics: create a free Pixabay account. Pixabay
has no "get a key" button. Once you're logged in, your key is shown on the
[API page](https://pixabay.com/api/docs/) in the **Parameters** table, on the `key` row
(it reads `Your API key:` followed by the key). Copy that and add it on a `PIXABAY_API_KEY`
line in `~/.config/img/keys.env`, the same file as your Pexels key.

## Usage

```
/img coffee beans
```

Run `/img` on its own and it asks you what to search for, how many images, and which
orientation. Search several things at once by separating them with commas:

```
/img massage therapy, healthy food, modern office
```

It writes the gallery to `/tmp/image-results.html` and opens it in your browser. Click any
image to enlarge, Download for the high-res file, or Copy URL for the image link.

## Notes

- **Key resolution:** `/img` uses an environment variable if set, then a project `.env`,
  then `~/.config/img/keys.env`. The `.env.example` shows the format.
- **Licensing:** this command is MIT (see `LICENSE`). Pexels and Pixabay images are free
  under their own licenses ([Pexels](https://www.pexels.com/license/),
  [Pixabay](https://pixabay.com/service/license-summary/)); the generated page credits each
  creator and links back to the source, as both require.
- **Platforms:** opens results with `open` (macOS), `xdg-open` (Linux), or `start`
  (Windows). Otherwise it's just `curl` and HTML, so it runs wherever your CLI runs shell
  commands.
