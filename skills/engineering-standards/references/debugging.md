# Systematic Debugging

**Iron law: NO FIX WITHOUT ROOT CAUSE INVESTIGATION FIRST.**

A symptom fix is a failure, even when the symptom disappears. Use this for any technical issue:
test failure, production bug, unexpected behavior, performance problem, build failure, flaky
integration. Especially under time pressure — emergencies are what make guessing tempting, and
systematic is faster than thrashing.

Complete each phase before the next.

## Phase 1 — Root cause investigation

1. **Read the error completely.** Full stack trace, line numbers, file paths, error codes. The
   answer is often already in it. Don't skip warnings.
2. **Reproduce consistently.** Exact steps. Every time? If not reproducible, gather more data —
   do not guess.
3. **Check recent changes.** `git diff`, recent commits, new dependencies, config changes,
   environment differences between where it works and where it doesn't.
4. **Instrument component boundaries** (multi-component systems only). Before proposing any fix,
   log what enters and what exits each boundary — request → service → repository → DB, or
   CI → build → package → deploy. Run once to gather evidence showing *where* it breaks, then
   investigate only that component. Guessing which layer fails wastes more time than measuring.
5. **Trace the data flow backwards.** Where does the bad value originate? What called this with
   it? Keep walking up until you reach the source. Fix at the source.

## Phase 2 — Pattern analysis

1. **Find working examples** of the same thing in this codebase.
2. **Read the reference implementation completely** if you are applying a known pattern. Read
   every line; don't skim.
3. **List every difference** between working and broken, however small. "That can't matter" is
   how the cause gets skipped.
4. **Check dependencies:** required components, settings, environment, implicit assumptions.

## Phase 3 — Hypothesis and test

1. **One hypothesis, stated explicitly:** "I think X is the root cause because Y."
2. **Smallest possible change** to test it. One variable at a time. Never fix several things at once.
3. **Verify before continuing.** Worked → Phase 4. Didn't → form a *new* hypothesis; do not stack
   another fix on top of the failed one.
4. **When you don't know, say so.** "I don't understand X" is a valid, useful statement. Research
   or ask; do not fabricate a mechanism.

## Phase 4 — Implementation

1. **Write the failing test case first** — simplest possible reproduction (see `tdd.md`). Required
   before the fix, not after.
2. **One fix, addressing the root cause.** No "while I'm here" improvements, no bundled refactor.
3. **Fix where all callers route through.** Before editing, find every caller of the function you
   are about to touch. One guard in the shared function is both the smaller diff and the correct
   fix; patching only the reported path leaves sibling callers broken.
4. **Verify** (see `verification.md`): the new test passes, no other test broke, the original
   symptom is gone.

## The 3-fix rule

Count your attempts. If three fixes have failed, **stop patching and question the design.**
Three failures means the model of the problem is wrong, not that the fourth patch is the right one.
Surface it: "Three attempts failed. The likely issue is [structural cause]. Options: [A] / [B]."

## Red flags

Trying a fix "to see what happens" · changing several things at once · "it's probably X" without
evidence · reading only the last line of the stack trace · adding a retry/timeout/sleep to make
a race go away · disabling the failing test.
