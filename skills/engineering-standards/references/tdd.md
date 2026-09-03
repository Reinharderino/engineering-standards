# Test-Driven Development

**Iron law: NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.**

If you did not watch the test fail, you do not know that it tests the right thing. A test written
after the code is a test that passes for reasons you never verified.

## Scope

**Always:** new features, bug fixes, behavior changes, refactors (existing tests must stay green).

**Ask before skipping:** throwaway prototypes and spikes, generated code, pure configuration.
Skipping is a decision the user makes, not one you make silently. Thinking "just this once" is the
rationalization, not the exception.

Wrote the code before the test? Delete it. Don't keep it as reference, don't "adapt" it while
writing tests, don't look at it. Implement fresh from the test.

## RED → GREEN → REFACTOR

### RED — write one failing test
One behavior. Clear name describing the behavior, not the function. Real code over mocks; mock
only what you cannot run (network, clock, payment gateway).

Good: `test('retries a failed operation 3 times')` exercising the real function and asserting the
observable outcome.
Bad: `test('retry works')` asserting that a mock was called — that tests the mock, not the code.

### Verify RED — mandatory
Run it. Confirm it **fails**, not errors, and that the failure message is the expected one
(feature missing — not a typo, import error, or bad fixture).
- Test passes already? You are testing existing behavior. Fix the test.
- Test errors? Fix the error and re-run until it fails *correctly*.

### GREEN — minimal code
The simplest thing that makes the test pass. No extra options, no configurability the test does
not demand, no "improving" adjacent code. Over-engineering here is the most common leak
(`maxRetries`, `backoff`, `onRetry` when the test asked for three retries).

### Verify GREEN — mandatory
Run it. The test passes, the other tests still pass, and the output is clean — no new warnings or
stderr noise.

### REFACTOR
Now clean up, with the tests as the safety net. Stay green after every step.

## Proportional testing

The pyramid: unit tests are fast, isolated, no I/O, and the majority · integration tests verify
boundaries (DB, external APIs, adapters) · end-to-end tests are few and cover critical paths only.

- **Test behavior, not implementation.** A test that knows about private methods breaks on every
  refactor and protects nothing.
- **Arrange–Act–Assert.** One assertion concept per test.
- **Test code is production code.** Same naming, same clarity standards.
- **No new behavior without a new test.** Refactors require the existing suite to pass.
- **Throwaway-tier work still leaves one runnable check** — the smallest thing that fails if the
  logic breaks: an assert-based self-check or one small test file. No frameworks or fixture
  scaffolding unless the project already has them. Trivial one-liners need no test; YAGNI applies
  to tests too.

## Bug fixes specifically

The regression test must fail *before* the fix and pass *after*. If it passes before the fix, it
does not reproduce the bug and it is not the test you need.
