# shared-harness

A [Claude Code](https://code.claude.com) **plugin marketplace** holding harness
content — skills, agents, and hooks — shared across my software projects.

Projects opt in once. After that, pushing to `main` here reaches every project
automatically: Claude Code background-updates installed plugins from the
default branch.

## Plugins

| Plugin | Description |
| --- | --- |
| `core` | Baseline harness shared across projects. Currently a placeholder. |

## Use it in a project

Two steps: register the marketplace, then install the plugin. The install is
what enables the plugin — you don't hand-edit `enabledPlugins`.

Both commands take `--scope`:

| Scope | Written to | Who gets it |
| --- | --- | --- |
| `user` (default) | `~/.claude/settings.json` | You, in every project |
| `project` | `.claude/settings.json` | Committed; everyone on the repo |
| `local` | `.claude/settings.local.json` | You, this repo only |

### From your shell

Scriptable, no prompts:

```bash
claude plugin marketplace add joehuang610154/shared-harness --scope project
```

```bash
claude plugin install core@shared-harness --scope project
```

Use `--scope user` instead if you want the harness in every project on this
machine without touching any repo.

### From inside Claude Code

```
/plugin marketplace add joehuang610154/shared-harness
```

```
/plugin install core@shared-harness
```

`/plugin install` opens the plugin's detail view and asks for the scope. Run
`/plugin` on its own for the full manager — Discover, Installed, Marketplaces,
Errors.

### What gets written

With `--scope project`, both keys land in the project's `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": {
    "shared-harness": {
      "source": { "source": "github", "repo": "joehuang610154/shared-harness" }
    }
  },
  "enabledPlugins": { "core@shared-harness": true }
}
```

You *can* write this by hand — it's a plain settings file, and the keys merge
with whatever else is in there. The commands are just less error-prone.

The first time Claude Code opens a project whose committed settings declare a
marketplace, it shows the workspace-trust dialog. The marketplace registers
after you trust the folder.

### For collaborators

Committing `.claude/settings.json` registers the marketplace for everyone, but
since Claude Code v2.1.195 it does not necessarily *install* a plugin on their
machine — for plugins that resolve to an external source, each person still runs
`claude plugin install`. Claude Code reports the plugin as not installed and
prints the exact command. Assume a one-line step per collaborator.

### Updates

Automatic. Claude Code refreshes marketplaces in the background, and no plugin
here sets a `version`, `ref`, or `sha`, so projects always follow `main`.

Note that third-party marketplaces have auto-update **disabled** by default;
turn it on under `/plugin` → **Marketplaces** → select `shared-harness` →
**Enable auto-update**.

To pull an update immediately:

```
/plugin marketplace update shared-harness
```

Then `/reload-plugins` to apply it without restarting.

## What this marketplace does *not* ship

A shared `CLAUDE.md`. Plugins can carry skills, agents, commands, hooks, MCP and
LSP servers, monitors, and executables — but Claude Code has no mechanism for a
plugin to supply project memory. Each project writes its own `CLAUDE.md`.

## Adding a plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json`:

   ```json
   {
     "name": "<name>",
     "description": "...",
     "author": { "name": "joehuang610154" }
   }
   ```

2. Add component directories at the **plugin root** — `skills/`, `agents/`,
   `hooks/`. Never inside `.claude-plugin/`; only `plugin.json` goes there.

3. Register it in `.claude-plugin/marketplace.json`:

   ```json
   { "name": "<name>", "source": "./plugins/<name>", "description": "..." }
   ```

4. Omit `version` everywhere, or consuming projects stop auto-updating.

5. Validate and test:

   ```bash
   claude plugin validate .
   ```

   ```bash
   claude --plugin-dir ./plugins/<name>
   ```

Skills are invoked as `/<plugin>:<skill>`.
