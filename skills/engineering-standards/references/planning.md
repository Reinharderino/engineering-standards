# Planning: Brainstorm → Design → Plan → Execute

Process weight scales with the task. The **approval gate never scales** — no implementation
action, no scaffolding, no code, until you have said what you intend and the user has agreed.

## Classify first, out loud

State the classification so the user can override it before you spend effort on the wrong path.

| Path | What it is | Output before code |
|---|---|---|
| **Spike** | A feasibility question — "can we…", "is it possible…", quick-and-dirty acceptable. The deliverable is an answer, not code you keep. | 2–3 sentences: the question and what you'll try. Then find out as cheaply as correctness allows. Anything built stays labeled throwaway. |
| **Bounded** | A well-scoped change to a flow that **already exists in this repo** and that you can read. A flag, a small endpoint, a one-file fix. | Clarifying questions that matter, then a short design in chat (a few sentences to a few paragraphs). Stop. Implement after approval. |
| **Architectural** | New projects, new subsystems, changes that restructure how components fit together or alter interfaces others depend on. | Questions → options with tradeoffs → sectioned design → written spec → written plan. |

Knowing what kind of application it is does not make a task bounded — bounded means the flow you
are changing is here to read. **In doubt, take the heavier path.** The ratchet is one-way: hidden
complexity found mid-task upgrades the path; say so and step up. Nothing downgrades mid-task.

"Too simple to need approval" is the anti-pattern that produces the wrong feature quickly.

## Written plans (architectural path, multi-session, or handoff)

Location: `docs/plans/YYYY-MM-DD-<feature>.md` (or wherever the project keeps them).

Write for an engineer who is skilled but has zero context on this codebase and domain. Everything
they need is in the plan: files to touch, how to test, what to read first.

**Structure:**
1. **Header** — goal in one paragraph, the spec/requirements it implements, how to verify the
   whole thing is done.
2. **File map** — every file created or modified and what each is responsible for. This is where
   decomposition gets locked in: one clear responsibility per file, files that change together
   live together, split by responsibility rather than by technical layer. In an existing codebase,
   follow the established patterns rather than unilaterally restructuring.
3. **Tasks** — a task is the smallest unit that carries its own test cycle and is worth a fresh
   reviewer's gate. Fold setup, config and docs into the task whose deliverable needs them; split
   only where a reviewer could reject one task while approving its neighbor. Each task ends with
   an independently testable deliverable.
4. **Steps within a task** — one action each, 2–5 minutes: write the failing test · run it and
   watch it fail · implement the minimal code · run the tests · commit.

If the spec spans several independent subsystems, break it into one plan per subsystem. Each plan
must produce working, testable software on its own.

## Executing a plan

- Work the tasks in order. One task at a time, complete, before starting the next.
- Each task ends green: tests pass, verification run (see `verification.md`), commit proposed.
- **The plan is a living document.** When reality contradicts it, stop and update the plan, then
  continue. Silently diverging from the plan destroys its value as a handoff.
- Discovered work that is not in the plan gets surfaced, not absorbed. "While I was there I also…"
  is how a reviewable diff becomes an unreviewable one.
