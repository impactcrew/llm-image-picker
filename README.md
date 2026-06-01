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

### 1. Get a free Pexels API key

Sign up at https://www.pexels.com/api/ and create a key. It is free.

### 2. Add the key to your shell

Add this to `~/.zshrc` (or `~/.bashrc`):

```bash
export PEXELS_API_KEY="your_key_here"
```

Then reload your shell:

```bash
source ~/.zshrc
```

### 2b. (Optional) Add a Pixabay key

Pixabay adds illustrations and vector graphics, not just photos. It is entirely optional:
if you skip it, the command stays Pexels-only and never mentions Pixabay. To enable it,
get a free key at https://pixabay.com/api/docs/ and add:

```bash
export PIXABAY_API_KEY="your_key_here"
```

When this key is present, `/img` asks whether to search Pexels, Pixabay, or both.

### 3. Install the command

`img.md` is a plain Markdown instruction file. Any agentic LLM CLI that can run shell
commands and read/write files can use it. Add it as a custom command or prompt in your
tool, or just paste its contents into the chat.

Claude Code (exact paths):

```bash
cp img.md ~/.claude/commands/img.md      # available in every project
# or, for a single project only:
cp img.md .claude/commands/img.md
```

Other tools (Cursor, Aider, Gemini CLI, Codex, and similar): add `img.md` as a custom
command or prompt using that tool's own mechanism, or paste its contents into the chat.
The procedure inside is tool-neutral: it asks what you need in plain text, calls the
image APIs with `curl`, and writes a local HTML page.

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
