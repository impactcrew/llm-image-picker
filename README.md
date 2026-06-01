# /img: Royalty-Free Image Search for Agentic LLM CLIs

A single slash command that searches [Pexels](https://www.pexels.com/) (and optionally
[Pixabay](https://pixabay.com/)) for royalty-free images and builds a clickable picker
page: a grid of results with click-to-enlarge, download buttons, copy-URL buttons, and
creator credits.

No agents, no plugins, no runtime dependencies. A Markdown command and your own free API
key, kept in one config file under your home folder (`~/.config/img/`).

It's not tied to any single tool. The instructions are plain text, so it works in any
agentic LLM CLI that can run shell commands and read/write files: Claude Code, Cursor,
Aider, Gemini CLI, Codex, and others.

## Setup

One-time, a couple of minutes. You won't touch your shell config, and you don't need to
know what an environment variable is.

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

`/img` works in every project, so its key lives in one global config file under your home
folder. Set it once and it works everywhere.

1. Get a free Pexels key: open https://www.pexels.com/api/, sign up (free, no credit
   card), and copy your key.
2. Create the config file:

   ```bash
   mkdir -p ~/.config/img && touch ~/.config/img/keys.env
   ```

   Then open `~/.config/img/keys.env` in your editor (`open` on macOS, `xdg-open` on
   Linux), or just open it the way you normally open a file.
3. Add your key on the `PEXELS_API_KEY` line and save:

   ```
   PEXELS_API_KEY=your_key_here
   ```

That's it. `/img` reads this file from any folder.

Why it's set up this way, in plain terms:
- Your key lives in a dedicated config file, never in your code and never in an AI chat.
- The file sits under your home folder, outside any project, so it can't be committed to
  a repo by accident.
- One file, every project. You never repeat this per project.

Optional: add a free Pixabay key (https://pixabay.com/api/docs/) on a `PIXABAY_API_KEY`
line for illustrations and vectors. Leave it out to stay Pexels-only.

> Never paste an API key into an AI chat. Type it into the config file in your editor
> instead. Anything sent to the assistant goes to the model provider and may be stored.
> `/img` refuses a key pasted into chat and points you back to the config file.

### Advanced: other ways to provide the key

`/img` checks three places in order and uses the first key it finds:

1. An environment variable that's already set. Handy for CI or power users:
   `export PEXELS_API_KEY="..."` in `~/.zshrc` (zsh) or `~/.bashrc` (bash).
2. A project-local `.env` in the folder you run `/img` from. Add a `PEXELS_API_KEY=` line
   and keep `.env` in that project's `.gitignore`. Use this for a per-project key.
3. The global `~/.config/img/keys.env` from Step 2.

The global file is simplest for most people. The `.env.example` in this repo shows the key
format for whichever file you choose.

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

The command writes the results page to `/tmp/image-results.html` and opens it in your
browser. Click any image to enlarge, use Download for the high-res file, or Copy URL to
grab the original image link.

## How it works

1. Finds your key (environment variable, project `.env`, or the global config file, in
   that order).
2. Calls the Pexels search API once per term, and Pixabay too if you added a Pixabay key,
   saving the JSON to `/tmp`.
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
Windows `start`. Everything else is plain `curl` and HTML, so it runs wherever your CLI
can run shell commands.
