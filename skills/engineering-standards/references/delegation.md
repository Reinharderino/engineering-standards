# Delegation: Subagents and Parallel Work

Delegate to keep the main thread's context on the *problem* rather than on file dumps. A subagent
starts cold: it inherits none of your reasoning, so context quality decides output quality.

## When delegating pays

| Delegate | Keep inline |
|---|---|
| Broad search across many files where you need the conclusion, not the dumps | A change you already know how to make |
| Independent tasks that can run in parallel (separate files, no shared state) | Anything needing the conversation's accumulated context |
| A fresh-eyes review of a diff you wrote | Small, bounded edits — the round trip costs more than the work |
| Bulk mechanical work (docstrings, translations, boilerplate) | Design decisions and pattern choices |

Do not delegate to avoid thinking. A confident wrong answer costs more than the tokens saved.

## Briefing a subagent (TOON)

- **Task** — the specific objective, and the boundary of what NOT to touch.
- **Outcome** — success criteria concrete enough to verify.
- **Objects** — the files, paths, SHAs, constraints and prior decisions it needs. It cannot see
  your session.
- **Next** — the exact form of the report you want back.

## Parallel dispatch

Only for genuinely independent work. Two agents editing the same file is a merge conflict you
created on purpose. Split by file boundary or module boundary, never by "half the feature each".

## Verifying agent output — mandatory

**An agent reporting success is not evidence.** Read the diff. Run the tests. A subagent that
cannot find the file often reports a plausible summary of work it did not do
(see `verification.md`).

## Isolated branches / worktrees

For work that must not disturb the working tree — a long refactor, a risky experiment, parallel
features — use a separate branch or a git worktree.

```bash
git worktree add ../<repo>-<feature> -b feature/<name>
# work, commit, then:
git worktree remove ../<repo>-<feature>
```

Rules: one worktree per unit of work · the branch follows the naming convention in the baseline (§10, Git Discipline) · clean it
up when merged or abandoned — abandoned worktrees rot and get committed to by accident · never
create one without telling the user where it is.
