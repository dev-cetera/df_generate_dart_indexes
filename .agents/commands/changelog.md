---
description: Draft a CHANGELOG.md entry from the current diff and recent commits, following the format pub.dev's pana analyser expects. Pass an optional version arg to target a specific entry.
argument-hint: "[version]"
allowed-tools: Bash, Read, Edit, Write
---

# /changelog — draft a CHANGELOG entry from the diff

Reusable across every Dart/Flutter package in the `df_packages` workspace.
The output **must** satisfy pub.dev's analyser (pana) so the package keeps
its full score on the "package has a CHANGELOG.md file" and "documents the
current release" rules.

**The CHANGELOG is for the pub.dev audience — downstream consumers of the
package.** It is *not* a project diary. Only changes that affect how a
consumer writes code against this package belong in it.

## What counts as "critical" — these are the only things to include

Include a bullet only when at least one of these is true:

- **Public API change** — anything in `lib/` (excluding files under `lib/src/`
  that are not re-exported, and any `_*.dart` private file) was added,
  removed, renamed, or had its signature changed.
- **Behavioural change visible to a caller** — same function still exists
  and has the same signature, but the values it returns, the conditions
  under which it throws, the order in which it does things, or the
  performance characteristics changed enough to affect callers.
- **Bug fix that changes runtime behaviour** — fixes that callers would
  notice. Mention the symptom in 5–10 words.
- **Dependency change visible to consumers** — bumping the SDK constraint,
  changing the minimum Flutter version, adding/removing a required
  dependency, raising the major version of an existing dep.

## What to skip — never include these

Even if they show up large in the diff, leave them out. They are not
useful to a pub.dev reader looking at your package's changelog.

- **CI / build / workflow changes** — anything under `.github/`, `.gitlab/`,
  or other tooling directories. The release pipeline is internal.
- **Test changes** — additions, refactors, deletions of test files.
  Tests change all the time and don't affect consumers.
- **Documentation of any kind** — `README.md`, `CLAUDE.md`, `.github/_README.md`,
  internal ADRs, slash commands, contributor guides, doc-comment edits inside
  source files, example-app README updates. Docs never belong in the
  CHANGELOG. The only doc-related exception: if a previously-undocumented
  public API got formal documentation that *callers* should now read, that
  is still not a changelog item — link it in the README instead.
- **Lint / formatter / `analysis_options.yaml` changes** — tightening or
  loosening lints is invisible to consumers.
- **Generated files** — `*.g.dart`, `_src.g.dart`, anything regenerated
  from a script.
- **Internal renames** — renaming a private class, private function, or a
  file under `lib/src/` that isn't re-exported. If the public API didn't
  change, callers won't notice.
- **Formatting-only commits** — `dart format` runs, whitespace, comment
  reflow.
- **Example app changes** — `example/` is a demo, not the package.
- **Refactors with no behavioural delta** — if the public surface and the
  observable behaviour are unchanged, it doesn't ship in the changelog.
  `refactor:` prefix is allowed only when downstream code may need to
  adjust (e.g. a class moved between barrel exports).
- **`pubspec_overrides.yaml`, `pubspec.lock`, `.dart_tool/`** — environment
  artefacts.

When in doubt, ask: "would a downstream user of this package notice if I
left this bullet out?" If the answer is no, leave it out.

## pana requirements — non-negotiable

These are the rules pana enforces. Verify each one before you finish:

1. **Filename:** `CHANGELOG.md` at the package root (sibling of `pubspec.yaml`).
2. **Top-level heading:** the file starts with `# Changelog` (or some other
   `# `-level heading). Don't remove or rename it.
3. **Version headings:** each release must be a markdown `##` heading whose
   text contains the version string. Any of these are accepted:
   - `## 1.2.3`
   - `## [1.2.3]`
   - `## v1.2.3`
   - `## [v1.2.3]`
   - With optional trailing date, e.g. `## 1.2.3 - 2026-05-22`
4. **Version-match:** the version field in `pubspec.yaml` **must** appear
   verbatim as one of the `##` headings. If pubspec is `1.2.3+4`, the
   heading text must include `1.2.3+4` (not just `1.2.3`). pana strips a
   leading `v` and the `[`/`]` brackets before matching.
5. **Ordering:** newest version on top. pana doesn't strictly require this,
   but every existing entry in this workspace follows it, so keep the
   convention.
6. **At least one bullet:** an empty version section is allowed by pana but
   useless to readers — write at least one meaningful bullet, or stop and
   tell the user there's nothing to record.

## What you should do

1. **Figure out the target version.**
   - If `$ARGUMENTS` was provided, normalise it (strip any leading `v`,
     strip brackets). Use that exact string.
   - Otherwise, read `version:` from `pubspec.yaml` in the current working
     directory. This must be a **runtime** read at command-execution time,
     not a guess.

2. **Gather the evidence.** Run, in parallel:
   - `git status --porcelain` — what's currently uncommitted.
   - `git diff HEAD` — full uncommitted diff (staged + unstaged).
   - `git log --oneline -n 20` — recent commits.
   - If a previous tag exists, also run `git log <last-tag>..HEAD --format=%s`
     to scope changes since the last release.

3. **Filter the diff against the "critical" rules above** before composing
   any bullets. If a file falls entirely under the skip list, ignore every
   line of its diff. Don't write a bullet you'll then have to delete.

4. **Read the existing `CHANGELOG.md`** so you can:
   - Match the heading style **already used in this file** exactly.
     Don't switch between `## 1.2.3` and `## [1.2.3]` mid-file.
   - Detect whether an entry for the target version already exists. If it
     does, *merge* new bullets into it rather than duplicating the heading.
   - Detect any `## [next]` / `## [unreleased]` placeholders and fold them
     into the new versioned section.

5. **Synthesize bullets.** Group by intent, not by file. One bullet per
   user-visible change. Prefixes — only when they genuinely apply:
   - `breaking:` — public API or documented behaviour change that requires
     downstream code edits. Most important prefix; be conservative.
   - `feat:` — new public functionality.
   - `fix:` — corrects a bug. Mention the symptom in 5–10 words.
   - `perf:` — measurable performance improvement.
   - `refactor:` — only when downstream code might need to adjust (e.g. a
     re-exported class moved). Internal-only refactors are skipped, not
     listed.

   Notably absent from the list of acceptable prefixes: `test:`, `ci:`,
   `chore:`, `build:`, `docs:`. If you're tempted to use one of those,
   re-check the skip list — the change probably doesn't belong in the
   CHANGELOG at all.

6. **Verify version-match before writing.** Re-read `pubspec.yaml`. The
   target-version string you're about to insert **must** equal the
   `version:` field (after normalising both for whitespace and the optional
   leading `v`). If they disagree, stop and tell the user — fixing the
   mismatch is their call, not yours.

7. **Apply the change.** Use the `Edit` tool to insert the new section
   directly below the top-level `# Changelog` heading (newest at the top).
   If the target version's section already exists, merge bullets in
   meaningful order (group by prefix), deduplicating.

8. **Final sanity check.** Read the file back and verify:
   - The first `##` heading contains the target version.
   - The target version matches `pubspec.yaml`'s `version:` field.
   - At least one bullet under the new heading.
   - No leftover placeholder sections.
   - No bullets that fall under the skip list slipped in.

9. **Don't commit.** The user controls when to commit.

## Behavioural notes

- Don't invent changes. Every bullet must trace to either the diff or a
  recent commit subject *and* clear the "critical" bar above.
- Don't pad with vague bullets like "general improvements" — if there's
  nothing critical to list, write one short paragraph in place of the
  version section explaining there are no consumer-visible changes, or
  stop and tell the user.
- The legacy `- Released @ MM/YYYY (UTC)` line is being phased out — don't
  add it to new entries unless the surrounding file uses it consistently.
- Be terse. One line per change. No paragraphs.
- Strict semver: if you spot a breaking change but the patch version was
  bumped instead of the major, flag it for the user before writing the
  entry — don't silently soften the description.

## Arguments

- `$ARGUMENTS` — optional. The version string for the entry (e.g. `0.17.0`).
  If empty, fall back to the `version:` field in `pubspec.yaml`.
