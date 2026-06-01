# /img: Royalty-Free Image Search for Agentic LLM CLIs

A single slash command that searches [Pexels](https://www.pexels.com/) (and optionally
[Pixabay](https://pixabay.com/)) for royalty-free images and builds a clickable picker
page: a grid of results with click-to-enlarge, download buttons, copy-URL buttons, and
creator credits.

No agents, no plugins, no runtime dependencies. A Markdown command, a small setup script,
and your own free API key.

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

### Step 2: Add your free API key

1. Get a free Pexels key: open https://www.pexels.com/api/, sign up (free, no credit
   card), and copy your key.
2. In your own terminal, run the setup script. It asks for your key with hidden input and
   saves it to your shell profile, then you are done:

   ```bash
   ./setup.sh
   ```

   Open a new terminal afterward (or run `source ~/.zshrc`). The script also offers an
   optional free Pixabay key (https://pixabay.com/api/docs/) for illustrations and
   vectors. Skip it and `/img` stays Pexels-only.

> Never paste an API key into an AI chat. Anything you type to the assistant is sent to
> the model provider and may be stored. The setup script exists so your key is typed into
> your own terminal with hidden input and stays on your machine. `/img` itself is built to
> refuse a key pasted into chat and point you here instead.

### Prefer to do it by hand?

Add this to your shell profile (`~/.zshrc` for zsh, `~/.bashrc` for bash) and open a new
terminal:

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
