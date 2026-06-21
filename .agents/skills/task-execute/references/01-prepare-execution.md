# Prepare Execution

Turn the approved plan into an execution checklist.

## Restate Before Editing

Before editing, restate:

- approved changed behavior in one sentence
- size/risk classification from the plan, or recomputed from representation concerns
- representations that must stay in sync
- immediate blockers versus work that can run in parallel
- approved subagent budget for implementation and review

## Checklist

Track:

- files or modules to edit
- representations to update
- acceptance criteria
- verification steps
- rollback or guardrail notes
- contradiction-search targets
- stable integration points
- reviewer-assigned concerns from planning

## Allowed Confirmation

Limit pre-implementation investigation to the minimum needed for the next safe edit:

- confirm the exact file, function, or existing test to edit
- check the current call path before patching
- open nearby tests or stories already in approved scope

Do not rediscover representation categories, redefine scope, reconstruct the plan, or run broad research that belongs in `$task-plan`.

Use `update_plan` when the work is Medium or Large.
