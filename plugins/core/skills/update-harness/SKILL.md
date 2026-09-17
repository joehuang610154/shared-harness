---
name: update-harness
description: Pull the latest harness now. Refresh every marketplace, then update each installed plugin at the scope it is installed in. Run only when the user asks.
disable-model-invocation: true
---

# Update Harness

## Steps

1. Record what is installed:

   ```bash
   claude plugin list --json
   ```

   Keep each plugin's `id`, `scope`, and `version`.

2. Refresh every marketplace:

   ```bash
   claude plugin marketplace update
   ```

3. Update each installed plugin at its own scope, one command per plugin:

   ```bash
   claude plugin update <id> --scope <scope>
   ```

   Never omit `--scope`. The default is `user`, and the update fails for a
   plugin installed at `project` or `local`.

4. Run `claude plugin list --json` again. Show one table:

   | Plugin | Scope | Before | After |
   |--------|-------|--------|-------|

   A plugin already current says so in the After column.

5. Name, in one line each, any plugin a marketplace offers that is not
   installed here. Find them with `claude plugin list --json --available`,
   keeping only marketplaces that already have a plugin installed.

6. Say that updates apply after `/reload-plugins` or a restart.

## Rules

- Update, do not install. Step 5 informs; installing is the user's call.
- Never edit `enabledPlugins` or `extraKnownMarketplaces` by hand. The CLI
  writes them.
- One failed update does not stop the rest. Report its message in the table
  and go on.
