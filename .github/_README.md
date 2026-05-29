# Release workflow

```
push to prod  →  prod.yml  →  pushes tag v{version}  →  publish.yml  →  pub.dev
```

## Day-to-day

Merge to `prod`. That's it. The workflow tests, bumps the version, writes a `CHANGELOG.md` stub, tags, and publishes.

Don't touch GitHub Releases — they're not part of the trigger chain.

## Auto-bump rules

Bump kind comes from the latest commit subject:

- `breaking:` or `feat!:` → major
- `feat:` → minor
- anything else → patch

To pick the version yourself, bump `version:` in `pubspec.yaml` before merging — the workflow respects pre-bumped versions and skips the auto-bump.

For richer `CHANGELOG.md` entries than the commit-subject stub, run the `/changelog` slash command locally before merging.

## One-time pub.dev setup

**pub.dev**: package page → **Admin** → enable **Automated publishing** with repo `<owner>/<repo>` and tag pattern `v{{version}}`.

**`RELEASE_PAT` secret** (repo or org secret): a classic PAT with `repo` scope, or a fine-grained PAT with `Contents: read+write` on this repo. Needed because tags pushed by the default `GITHUB_TOKEN` don't trigger `publish.yml`.

When the PAT expires, `prod.yml` fails at checkout with a clear auth error — regenerate and update the secret.
