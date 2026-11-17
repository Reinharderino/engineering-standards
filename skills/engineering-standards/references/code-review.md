# Code Review — Requesting and Receiving

Review early, review often. Issues caught at task boundaries cost a fraction of what they cost
after they cascade.

## Requesting a review

**Mandatory:** after completing a feature · before merging to the main branch · after each task
in an agent-driven workflow.
**Valuable:** when stuck (fresh perspective) · before a refactor (baseline) · after a complex fix.

Give the reviewer *crafted context*, never your session history:

```
Range:        <base-sha>..<head-sha>       # git rev-parse origin/main / HEAD
Built:        <what this change does, 2-3 lines>
Should do:    <the requirement or plan it implements>
Ask for:      correctness bugs, missed callers, security at trust boundaries,
              simplification/reuse opportunities. Severity-tag each finding.
```

What the reviewer owes:

- **Read past the diff.** Callers of every changed function, what it calls, its tests. A change
  can break code it does not touch: a changed signature, return value or behavior means grepping
  every caller.
- **State the load assumed** — one person running a script, or many users and processes at once —
  and judge scale against it: check-then-write races, per-item queries, unbounded growth, O(n²) on
  real input, per-process state that must be shared.
- **Every finding carries a concrete case:** "this input or situation produces this wrong result".
  No case, no finding. No "consider", no taste, no vague worries.
- **A marked shortcut (`upgrade:` comment naming its ceiling, §2) is a decision, not a finding** —
  unless the expected load already crosses that ceiling.
- **Spec silence is not permission.** Behavior the spec doesn't mention is judged by what a
  reasonable user would expect.
- **List what was declined.** Before the verdict, one line per behavior considered and set aside
  as out of scope, with the reason. The author rules on each; nothing is dropped silently.

Reviewer output format — one line per finding, most severe first:
`path:line: <severity>: <problem>. <fix>.`
End with a verdict (`ship` / `fix N first`) and `not checked:` for anything that mattered but
couldn't be verified.

Severities: **Critical** (data loss, security, incorrect behavior shipped) · **Important**
(bug under a reachable condition, missing validation at a boundary) · **Minor** (clarity, naming,
duplication). Skip pure formatting unless it changes meaning.

Act on it: Critical immediately · Important before proceeding · Minor noted, batched, or declined
with a reason.

## Receiving a review

Review is a technical evaluation, not a social exchange.

```
1. READ      the complete feedback without reacting
2. UNDERSTAND restate each item in your own words — or ask
3. VERIFY    check the claim against the actual codebase
4. EVALUATE  is it technically right for THIS codebase?
5. RESPOND   technical acknowledgment, or reasoned pushback
6. IMPLEMENT one item at a time, verifying each
```

**Never:** "You're absolutely right!" · "Great point!" · "Let me implement that now" *before*
verifying the claim. Performative agreement is how a wrong review comment becomes a bug.

**Instead:** restate the requirement, ask the clarifying question, push back with technical
reasoning when the comment is wrong for this codebase, or just start working — actions over words.

**Unclear feedback stops everything.** If items 4 and 5 of a six-item review are unclear, do not
implement 1, 2, 3, 6 and ask later — the items may be related, and partial understanding produces
the wrong implementation. Ask about all unclear items first.

A reviewer — human or agent — can be wrong. Verify before implementing; disagree with evidence,
not with deference.
