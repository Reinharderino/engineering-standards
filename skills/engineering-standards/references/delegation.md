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

Keep the brief short: objective, files it may create or edit, files it must read, acceptance
criteria written as tests, verification commands. Context the agent does not need is cost, not
help.

## Scope by file — the orchestrator's rules

- **Every brief lists the exact files** the agent may create or edit, and the ones it should read.
  Two parallel tasks never share a file. If two need the same file, they run in sequence, or the
  orchestrator makes that change itself.
- **Shared files belong to the orchestrator:** service/module registration, shared schema or DDL,
  shared contracts, routing and menus, translations, solution/workspace files, Dockerfiles. The
  agent reports the exact line to add ("pending registration") and does not apply it. A brief may
  hand one shared file to one agent by name, only when no parallel task touches it.
- **Contracts first.** If two tasks talk to each other, the orchestrator fixes the contract before
  dispatching either.
- **Work that needs a real environment is not delegated** — seeds, end-to-end runs against live
  services, third-party integration. The orchestrator does it, or the task is redesigned so tests
  can judge it.
- **Never resume or relaunch an agent without first reading what it left behind.** Half-done work
  is finished on the same branch, not redone on a new one.

Split by file or module boundary, never by "half the feature each".

## What the agent may do to verify — and nothing else

**The compiler, the linter and the tests are the only judges inside a subagent.** Allowed: build
the affected project, lint the touched files, run the affected tests (end-to-end only against
mocked services). The full suite runs once, at the end.

Forbidden inside a subagent: starting databases or containers, starting the app or API, HTTP calls
against any service, screenshots, scratch scripts or console apps to "try it", web searches (unless
the task *is* research), installing packages, merge, push, deploy. Manual verification is the
orchestrator's call, made once, after integration — it is where delegation cost explodes.

Same failure three times for the same cause → stop and report the exact error. Do not iterate.

Report back in ~15 lines: branch and commit · files changed · pending registrations · build, lint
and test commands with their numbers · assumptions and open items. No restating the brief, no
explaining the code.

## Inline vs agent-per-task

For executing a written plan, pick deliberately and say why:

- **Inline** — you implement every task in this session, then one fresh reviewer checks the whole
  branch. Cheapest. Right when tasks lean on each other's interfaces, or the plan already carries
  the design.
- **Agent per task** — a fresh agent implements each task and a fresh reviewer gates it before the
  next. Most thorough, one cold context per task and per review. Right when tasks are independent
  and a shipped mistake is expensive.

The user can veto delegation outright for a project; that holds until they lift it.

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
