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
- **Files every parallel task would touch belong to the orchestrator** — whatever the project uses
  to wire things together. The agent reports the exact change needed ("pending wiring") and does
  not apply it. A brief may hand one such file to one agent by name, only when no parallel task
  touches it.
- **Contracts first.** If two tasks talk to each other, the orchestrator fixes the contract before
  dispatching either.
- **Never resume or relaunch an agent without first reading what it left behind.** Half-done work
  is finished on the same branch, not redone on a new one.

Split by file or module boundary, never by "half the feature each".

## Verification inside a subagent

**The brief names the verification commands, and the agent runs those.** Whether that includes
live environments (containers, a running app, real services) is the project's call — say it in the
brief, don't leave the agent to decide. Acceptance criteria written as tests are the cheapest judge
an agent can't argue with. The full suite runs once, at the end, after integration.

Merge, push, deploy and installing packages stay with the orchestrator regardless (§11).

Same failure three times for the same cause → stop and report the exact error. Do not iterate.

Report back briefly: branch and commit · files changed · pending wiring · verification commands
with their results · assumptions and open items. No restating the brief, no explaining the code.

## Inline vs agent-per-task

For executing a written plan, pick deliberately and say why:

- **Inline** — you implement every task in this session, then one fresh reviewer checks the whole
  branch. Cheapest. Right when tasks lean on each other's interfaces, or the plan already carries
  the design.
- **Agent per task** — a fresh agent implements each task and a fresh reviewer gates it before the
  next. Most thorough, one cold context per task and per review. Right when tasks are independent
  and a shipped mistake is expensive.

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
