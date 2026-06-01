# /img — Royalty-Free Image Search for Agentic LLM CLIs

A single slash command that searches [Pexels](https://www.pexels.com/) (and optionally
[Pixabay](https://pixabay.com/)) for royalty-free images and builds a clickable picker
page: a grid of results with click-to-enlarge, download buttons, copy-URL buttons, and
creator credits.

No agents, no plugins, no dependencies. One Markdown file and your own free API key.

It is not tied to any single tool. The instructions are plain text, so it works in any
agentic LLM CLI that can run shell commands and read/write files: Claude Code, Cursor,
Aider, Gemini CLI, Codex, and others.

## Setup

One-time, about two minutes. You do not need to know what an environment variable is, and
you will not edit any system files by hand. Your AI assistant handles the technical part.

### Step 1: Add the command to your tool

`img.md` is a plain instruction file. Drop it into your AI coding tool once.

Claude Code:

```bash
cp img.md ~/.claude/commands/img.md      # available in every project
# or, for a single project only:
cp img.md .claude/commands/img.md
```

Other tools (Cursor, Aider, Gemini CLI, Codex, and similar): add `img.md` as a custom
command or prompt using that tool's own mechanism, or just paste its contents into the
chat.

### Step 2: Run it, paste your key when asked

1. Get a free Pexels key: open https://www.pexels.com/api/, sign up (free, no credit
   card), and copy your key.
2. Run `/img` in your tool. The first time, it sees you have no key, asks you to paste it,
   and offers to save it for you. That is the whole setup. You never open a config file.

Optional: grab a free Pixabay key too (https://pixabay.com/api/docs/) to also search
illustrations and vectors. Paste it the same way when the command asks, or skip it and
`/img` stays Pexels-only.

### Prefer to set the key yourself?

If you would rather not have the assistant do it, add this to your shell profile
(`~/.zshrc` for zsh, `~/.bashrc` for bash) and open a new terminal:

```bash
export PEXELS_API_KEY="your_key_here"
# optional second source:
export PIXABAY_API_KEY="your_key_here"
```

## Usage

In Claude Code:

```
/img coffee beans
```

Or run it with no argument to be prompted for search terms, count, and orientation:

```
/img
```

You can search several things at once by comma-separating them:

```
/img massage therapy, healthy food, modern office
```

The command writes the results page to `/tmp/pexels-results.html` and opens it in your
browser. Click any image to enlarge, use Download for the high-res file, or Copy URL to
grab the original image link.

## How it works

1. Checks that `PEXELS_API_KEY` is set.
2. Calls the Pexels search API once per term and saves the JSON to `/tmp`.
3. Reads that JSON and generates a self-contained HTML gallery (everything inline, works
   offline once loaded).
4. Opens the page for you to pick from.

## Licensing and attribution

This command is MIT licensed (see `LICENSE`). Pexels images are free under the
[Pexels License](https://www.pexels.com/license/); Pixabay images under the
[Pixabay Content License](https://pixabay.com/service/license-summary/). The generated
page credits each creator and links back to the source, as both APIs' guidelines require.
Keep those credits in place when you reuse the tool.

## Platform notes

The command opens the results page with `open` (macOS). On Linux it uses `xdg-open`, on
Windows `start`. Everything else is plain `curl` and HTML, so it works anywhere Claude
Code runs.
