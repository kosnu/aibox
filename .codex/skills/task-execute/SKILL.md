---
name: task-execute
description: Execute an approved repository task plan, use subagents where work can be split safely, and always run parallel review with subagents before final verification. Use when the user says "$task-execute" or asks to implement an approved plan.
argument-hint: "[approved plan or task description with explicit approval]"
---

# Task Execution Workflow

## Goal

Implement an already approved plan, keep the changed behavior synchronized across its representations, review the diff in parallel with subagents, and finish with verification.

## Entry Gate

Do not start implementation unless an approved plan already exists in the conversation or the user explicitly provides one.

Before editing:

- restate the approved changed behavior in one sentence
- restate the size classification if known, or recompute it from the approved plan
- restate the representations that must stay in sync
- identify the implementation steps that are immediate blockers versus those that can run in parallel

If there is no approved plan, stop and tell the user to run `task-plan` first or provide an approved plan directly.

## Step 1: Prepare Execution

Turn the approved plan into an execution checklist:

- files or modules to edit
- representations to update
- acceptance criteria
- verification steps
- rollback or guardrail notes
- contradiction-search targets
- integration points that must remain stable
- reviewer-assigned concerns carried over from planning

Use `update_plan` when the work is Medium or Large.

## Step 2: Decide Parallelization

At the start of execution, explicitly separate:

- what the main agent should do locally right now
- what can be delegated safely in parallel

Use subagents whenever there are independent tasks with disjoint or minimally coupled ownership.

- Prefer `worker` subagents for bounded implementation tasks
- Prefer `explorer` subagents for targeted read-only questions that unblock design or integration checks
- Define ownership clearly when delegating code changes, including files or modules
- Tell workers they are not alone in the codebase and must not revert others' changes
- Keep the main agent focused on integration, critical-path edits, and final verification

For Medium and Large work, subagent use is the default when there is any safe parallel split.

For Small work, subagent use is optional during implementation but mandatory during review.

If execution is kept local, explicitly state why the work is too small, too coupled, or too blocking to split safely.

## Step 3: Implement

Execute the approved plan while keeping representations synchronized.

- update the required representations directly
- keep user updates concise and factual as work progresses
- if scope changes materially, say so and reframe the size classification
- if the approved plan proves incomplete, pause and resolve the gap before continuing risky edits

## Step 3.5: Re-approval Gate

Do not continue on an implicitly rewritten plan.

Return for re-approval before continuing if any of the following happen:

- the size classification changes
- the write scope expands materially beyond the approved plan
- the changed behavior or acceptance criteria change
- the UX direction changes in a user-visible way
- the performance characteristics or risk profile change materially
- the integration sequence changes enough to affect rollout or verification strategy

For minor clarifications that do not change approved scope or behavior, proceed and note the clarification in the final summary.

## Step 4: Review In Parallel

Before final verification, always run review with subagents in parallel regardless of size.

The review must cover:

- regressions and edge cases
- missing or stale tests
- unsynchronized representations
- evidence that the old behavior still exists elsewhere
- contradictions to the current understanding of the changed behavior

Use at least two subagent reviewers so the review is actually parallel.

Assign distinct review ownership. At minimum:

- one reviewer owns behavior, regressions, and contradiction search
- one reviewer owns tests, stale assumptions, and verification gaps

When the work spans multiple subsystems or includes meaningful UX or performance impact, add reviewers or redistribute ownership so those concerns have explicit coverage.

Examples of good review splits:

- one reviewer checks behavior and edge cases while another checks tests and stale assumptions
- one reviewer checks one subsystem while another checks another subsystem
- one reviewer focuses on contradictions and leftover old behavior while another focuses on missing verification

Do not skip parallel review even for Small work.

## Step 5: Verify

Run the relevant checks for the affected area after review fixes are applied.

Treat completion as "no convincing contradiction found," not merely "tests passed."

## Step 6: Done

Summarize:

- outcome and changed behavior shipped
- verification run
- review findings fixed or remaining risks
- final synchronization status of each representation
- representations checked and intentionally unchanged

## Rules

- Never implement without an approved plan
- Never skip subagent-based parallel review
- Never satisfy the parallel review requirement with only one reviewer
- Never continue after a material plan change without re-approval
- No unrelated refactors or cleanup
- Keep tool usage specific and efficient
- Prefer behavior-level reasoning over file-level reasoning when the same rule may be represented in multiple places
- In review, treat one-sided updates as a likely bug even when tests pass
- Assume there may be undiscovered representations until contradiction search is complete
- Prefer searching for leftover evidence of the old behavior over searching only for support of the new behavior
- Scale the workflow up or down if the scope changes; tell the user when you do
