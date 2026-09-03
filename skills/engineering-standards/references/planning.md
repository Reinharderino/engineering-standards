# Planning: Brainstorm → Design → Plan → Execute

Process weight scales with the task. The **approval gate never scales** — no implementation
action, no scaffolding, no code, until you have said what you intend and the user has agreed.

## Classify first, out loud

State the classification so the user can override it before you spend effort on the wrong path.

| Path | What it is | Output before code |
|---|---|---|
| **Spike** | A feasibility question — "can we…", "is it possible…", quick-and-dirty acceptable. The deliverable is an answer, not code you keep. | 2–3 sentences: the question and what you'll try. Then find out as cheaply as correctness allows. Anything built stays labeled throwaway. |
| **Bounded** | A well-scoped change to a flow that **already exists in this repo** and that you can read. A flag, a small endpoint, a one-file fix. | Clarifying questions that matter, then a short design in chat (a few sentences to a few paragraphs). Stop. Implement after approval. |
| **Architectural** | New projects, new subsystems, changes that restructure how components fit together or alter interfaces others depend on. | Questions → agnostic solution → stack decision → sectioned design → written spec → written plan. |

Knowing what kind of application it is does not make a task bounded — bounded means the flow you
are changing is here to read. **In doubt, take the heavier path.** The ratchet is one-way: hidden
complexity found mid-task upgrades the path; say so and step up. Nothing downgrades mid-task.

"Too simple to need approval" is the anti-pattern that produces the wrong feature quickly.

## Solution before stack — the agnostic pass

**The solution is designed with no language, framework or library in it. The stack is chosen
afterwards, as a separate decision, from the solution.**

Reaching for a technology first inverts the problem: you end up shaping the requirement to fit the
tool you already had in mind, and the tool's constraints get mistaken for the domain's. Every
"we'll use X" stated before the problem is fully described is a decision made on familiarity, not
on fit.

### Pass 1 — state the solution in domain terms

No syntax, no library names, no framework nouns. What must be expressible:

- **Inputs and outputs** — what enters the system, in what shape, and what leaves.
- **The data and its shape** — entities, relationships, cardinality, what is authoritative.
- **Invariants** — what must always be true, and what must never happen. These are the rules the
  implementation cannot break regardless of stack.
- **The transformation** — the actual algorithm or process, in steps, in plain language.
- **State and lifetime** — what is remembered, for how long, and what happens when it is lost.
- **Failure behavior** — what happens on each failure mode, and which failures must not lose data.
- **Boundaries** — where the trust boundaries are, where the transaction boundaries are.
- **Scale and latency** — the numbers the solution has to hold, stated, not assumed.

Written well, this pass is portable: the same description can be implemented in any reasonable
stack, and a reviewer can find a logic error in it before a single line exists.

Test it: **if you cannot describe the solution without naming a technology, you do not understand
the problem yet.** A description that collapses without its framework was a framework tour, not a
design.

### Pass 2 — choose the stack, deliberately

Only now. Choose against the solution from pass 1, with the reasons visible:

- What the **existing codebase and team** already use — this usually wins, and needs no defense.
  Deviating from it does.
- What the **invariants** demand — strong consistency, hard real-time, memory ceiling, a specific
  numeric precision. These eliminate options; nothing else does as cleanly.
- **Operational reality** — what the target environment can actually run, deploy, monitor and
  patch. A stack nobody on call can debug at 3am is the wrong stack whatever the benchmark says.
- **Longevity** — will this be maintained in three years, and by whom.

Surface the choice using the decision format in §6, with a recommendation. Novelty and personal
preference are not criteria; say so plainly when they are what's driving a proposal — including
when it is yours.

### Proportionality

Spike: pass 1 is a sentence or two, and the stack is usually "whatever answers the question
fastest". Bounded: pass 1 is a short paragraph, and the stack is already decided by the repo —
say so and move on. Architectural: pass 1 is a section of the spec, and the stack choice gets its
own section with the tradeoffs written down.

The agnostic pass is a thinking discipline, not a deliverable ceremony. It scales down. It never
disappears.

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
