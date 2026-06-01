# /img: Royalty-Free Image Search for Agentic LLM CLIs

A single slash command that searches [Pexels](https://www.pexels.com/) (and optionally
[Pixabay](https://pixabay.com/)) for royalty-free images and builds a clickable picker
page: a grid of results with click-to-enlarge, download buttons, copy-URL buttons, and
creator credits.

No agents, no plugins, no runtime dependencies. A Markdown command and your own free API
key, kept in a local `.env` file.

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

This doubles as a quick security habit worth learning. Secrets go in a file called
`.env` that is kept out of git, so it is never shared or uploaded.

1. Get a free Pexels key: open https://www.pexels.com/api/, sign up (free, no credit
   card), and copy your key.
2. Make your own secrets file from the template:

   ```bash
   cp .env.example .env
   ```

3. Open `.env` in your editor, paste your key after `PEXELS_API_KEY=`, and save:

   ```
   PEXELS_API_KEY=your_key_here
   ```

That is it. `/img` reads `.env` automatically.

Why this is a good habit, in plain terms:
- Your key lives in `.env`, never in your code and never in an AI chat.
- `.env` is listed in `.gitignore`, so it is never committed or pushed to GitHub.
- `.env.example` is the shareable template with the values left blank. This is the
  standard pattern across almost every modern project, so it is worth getting used to.

Optional: add a free Pixabay key (https://pixabay.com/api/docs/) on the `PIXABAY_API_KEY`
line for illustrations and vectors. Leave it blank to stay Pexels-only.

> Never paste an API key into an AI chat. Type it into the `.env` file in your editor
> instead. Anything sent to the assistant goes to the model provider and may be stored.
> `/img` is built to refuse a key pasted into chat and point you back here.

### Using `/img` across many projects?

A `.env` lives in one project folder. If you would rather have your key available
everywhere, set it globally instead by adding this to your shell profile (`~/.zshrc` for
zsh, `~/.bashrc` for bash), then open a new terminal:

```bash
export PEXELS_API_KEY="your_key_here"
export PIXABAY_API_KEY="your_key_here"   # optional
```

`/img` uses a global environment variable if it does not find a `.env`.

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
