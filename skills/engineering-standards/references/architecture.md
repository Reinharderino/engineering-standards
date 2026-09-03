# Clean Architecture (Core / Production tier)

Applies in full only at the **Core/Production** tier (§2). At **Evolving**, take the dependency
rule and skip the ceremony. At **Throwaway**, none of this applies — one file that works is correct.

## Layers

```
┌─────────────────────────────────────────┐
│           Frameworks & Drivers          │  ← Web, DB, UI, external libraries
├─────────────────────────────────────────┤
│           Interface Adapters            │  ← Controllers, Presenters, Gateways
├─────────────────────────────────────────┤
│           Application Layer             │  ← Use cases / application services
├─────────────────────────────────────────┤
│             Domain Layer                │  ← Entities, Value Objects, Domain Services
└─────────────────────────────────────────┘
```

## Dependency rule (absolute)

- Dependencies point **inward only**. The domain knows nothing about the outside world.
- The domain layer has **zero imports** from frameworks, ORMs, HTTP libraries or external services.
  An ORM annotation on an entity is a violation, not a convenience.
- Cross-layer communication goes through **interfaces/ports defined in the inner layer**. The outer
  layer provides the adapter.

## Key patterns

- **Repository** — data access always behind an interface. The domain calls a port; infrastructure
  supplies the adapter.
- **Use case / interactor** — one class per business operation. No fat controllers, no god services.
- **DTOs at boundaries** — data crossing a layer boundary is transformed. No entity leakage into
  transport or persistence models.
- **Dependency injection** — dependencies are injected, never constructed inside the class that
  uses them.

## Modular monolith by default

- One deployable unit, hard internal boundaries by bounded context. Choose distributed services
  only when a named constraint (independent scaling, team autonomy, isolation requirement) forces
  it — never as a default.
- Each module owns its models, use cases and data access.
- Module A needing data from module B goes through a published interface or an event. **Never** a
  direct model import across modules.

## Domain contracts across services

When several applications share concepts, the canonical definition lives in one contract package
(schema-first), and language types are generated from it. Duplicated hand-written models across
services drift, and the drift is discovered in production.

## Applying SOLID deliberately

Before writing a class or module at this tier, name which principle each design decision serves.
A decision that violates one is flagged and an alternative proposed — not silently shipped.
The point is not ceremony: it is that "why is this an interface?" must have an answer other than
"that's the pattern".
