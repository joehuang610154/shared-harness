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

### Option A — install interactively

Run these once inside the project:

```
/plugin marketplace add joehuang610154/shared-harness
```

```
/plugin install core@shared-harness
```

### Option B — commit it to the project

Put this in the project's `.claude/settings.json` and commit it, so anyone who
clones the project gets the harness without running anything:

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

If the project already has a `.claude/settings.json`, merge these two keys into
it — don't replace the file.

On the next launch Claude Code shows the workspace-trust dialog. After you trust
the folder it registers the marketplace and enables the plugin.

### Updates

Automatic. Claude Code refreshes marketplaces in the background, and no plugin
here sets a `version`, `ref`, or `sha`, so projects always follow `main`.

To pull an update immediately rather than waiting:

```
/plugin marketplace update shared-harness
```

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
