# /img - Royalty-Free Image Search for AI Coding Tools

A slash command that searches [Pexels](https://www.pexels.com/) (and optionally
[Pixabay](https://pixabay.com/)) for royalty-free images and builds a clickable picker
page: a grid of results, click to enlarge, download and copy-URL buttons, and creator
credits.

One Markdown file plus your own free API key. Works in any agentic LLM CLI: Claude Code,
Cursor, Aider, Gemini CLI, Codex, and others.

## Setup

### 1. Install the command

Pick one:

- **In your AI tool:** paste this in. Your assistant fetches the file and installs it
  wherever your tool keeps commands. (It follows the URL you give it, so only do this with
  repos you trust.)

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
2. **Run `/img`.** With no key set, it creates `~/.config/img/keys.env`, opens it, and asks
   you to paste your key on the `PEXELS_API_KEY` line. Save and you're set, for every
   project.

Type the key into that file, never into the AI chat.

Optional, for illustrations and vector graphics: create a free Pixabay account, then find
[your Pixabay API key](https://pixabay.com/api/docs/) in the **Parameters** section of that
page (next to `key`, shown once you're logged in). Add it on a `PIXABAY_API_KEY` line in
the same file.

## Usage

```
/img coffee beans
```

Run `/img` with no argument to be prompted for search terms, count, and orientation, or
comma-separate several searches at once:

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
