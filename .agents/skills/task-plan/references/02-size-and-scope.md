# Size And Scope

Classify size by behavior concerns that must stay synchronized, not raw file count.

## Representation Concern

A representation concern is a behavioral surface or rule that can drift from the others if it is not updated with the same change.

Common concerns:

- UI or UX behavior
- state management
- validation
- API request/response mapping
- schema, migration, or database constraint
- domain types
- auth, permissions, payments, or other high-risk rules
- error handling
- routing
- tests, stories, fixtures, or mocks
- performance, accessibility, rollout, or backward compatibility

## Classification

- **Large:** 4 or more distinct concerns, cross-system contract changes, high-risk domains, database migrations, or irreversible data changes.
- **Medium:** 2-3 distinct concerns, or a moderately complex behavior change within one system where synchronization can drift.
- **Small:** 1 primary concern, even when reflected mechanically across multiple files using an established pattern.

Many files can still be Small when they repeat one established change pattern. Few files can still be Medium or Large when they combine multiple concerns or high-risk behavior.

## Scope Output

The plan should name:

- entry-point files or modules
- other expected files, modules, or test areas to touch
- explicit out-of-scope work
- representations intentionally left unchanged

If currently on `main` or `master`, recommend creating a work branch before implementation.
