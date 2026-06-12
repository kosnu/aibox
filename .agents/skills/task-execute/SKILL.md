---
name: task-execute
description: Execute an approved repository task plan, keep changed behavior synchronized, and use size/risk-based subagent budgets for implementation and review. Use when the user says "$task-execute" or asks to implement an approved plan.
argument-hint: "[approved plan or task description with explicit approval]"
---

# Task Execution Workflow

## Goal

Implement an already approved plan, keep the changed behavior synchronized across its representations, review the diff within the approved size/risk budget, and finish with verification.

Treat execution as execution, not planning. Once an approved plan exists, do not drift back into planning mode during this skill.

Repository rules, local patterns, and unstated conventions must still be respected during execution. Do not save rate limit by skipping grounding or review. Save rate limit by limiting subagent count according to the approved size/risk budget while the main agent owns critical-path implementation, integration, and final judgment.

## Entry Gate

Do not start implementation unless an approved plan already exists in the conversation or the user explicitly provides one.

If an approved plan exists, `task-execute` must not create a new plan.

At this stage, the only allowed pre-implementation work is:

- briefly restating the approved content
- organizing the immediate blockers versus the parts that can run in parallel
- doing the minimum code confirmation needed to start the next edit safely

Do not re-present an approval-ready plan during execution.

Before editing:

- restate the approved changed behavior in one sentence
- restate the size/risk classification if known, or recompute it from the approved plan using representation concerns rather than the raw number of files
- restate the representations that must stay in sync
- identify the implementation steps that are immediate blockers versus those that can run in parallel
- restate the subagent budget for implementation and review

If there is no approved plan, stop and tell the user to run `task-plan` first or provide an approved plan directly.

## Success Criteria

A successful `task-execute` response ships the approved changed behavior and reports:

- the implementation outcome
- the representations that were synchronized
- the verification that ran
- the review findings fixed or remaining risks
- the review budget used and why it fit the approved size/risk classification
- any representations checked and intentionally left unchanged
- any scope clarification that was handled without requiring re-approval

## Stop Rules

Stop execution and ask for re-approval when:

- the approved behavior or acceptance criteria would change
- the likely write scope expands materially beyond the approved plan
- the size/risk classification changes
- the UX direction, performance characteristics, rollout sequence, or verification strategy changes materially
- the approved plan is missing a representation that must change to keep behavior synchronized

Do not turn these stops into a new approval-ready plan inside `task-execute`. Report the gap and wait for the user to re-plan or approve the scope change.

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
- the approved subagent budget for implementation and review

Limit pre-implementation investigation to the minimum confirmation needed for the next code change.

Allowed examples:

- confirming the exact file or function name to edit
- checking the current call path before patching
- opening the nearby test or story that already belongs to the approved scope

Not allowed here:

- re-discovering representation categories
- redefining the scope
- reconstructing the plan from review perspectives
- broad exploratory research that belongs in `task-plan`

Use `update_plan` when the work is Medium or Large.

## Step 2: Decide The Execution Budget

At the start of execution, explicitly separate:

- what the main agent should do locally right now
- what can be delegated safely in parallel

Use subagents only when there are independent tasks with disjoint or minimally coupled ownership and the approved size/risk budget allows it.

- Prefer `worker` subagents for bounded implementation tasks
- Prefer `explorer` subagents for targeted read-only questions that unblock design or integration checks
- Define ownership clearly when delegating code changes, including files or modules
- Tell workers they are not alone in the codebase and must not revert others' changes
- Keep the main agent focused on integration, critical-path edits, and final verification

Any read-only check done here must stay narrowly scoped to immediate implementation needs.

Do not use subagents here to:

- rebuild an approval-ready plan
- perform `task-plan`-style reviewer validation before implementation starts
- expand the task into newly discovered representation categories unless re-approval is triggered
- generate a fresh approval gate such as "if this plan looks good, I will implement it"

Implementation subagent budget:

- **Small:** the main agent implements. Do not use worker subagents.
- **Medium:** use at most 1 worker only when ownership is clearly separated.
- **Large:** use multiple workers only when each has disjoint ownership and integration remains controlled by the main agent.

For Medium and Large work, subagents are allowed only when there is a safe split. If execution is kept local, briefly record the main-agent checks and why delegation would not reduce risk or latency.

## Step 3: Implement

Execute the approved plan while keeping representations synchronized.

- update the required representations directly
- keep user updates concise and factual as work progresses
- if scope changes materially, say so and reframe the size classification
- if the approved plan proves incomplete, pause and resolve the gap before continuing risky edits

If additional investigation reveals that the approved plan is missing something material, stop instead of silently re-planning inside execution.

## Step 3.5: Re-approval Gate

Do not continue on an implicitly rewritten plan.

If re-planning becomes necessary during implementation, stop at that point and ask for re-approval instead of rebuilding the plan inside `task-execute`.

Return for re-approval before continuing if any of the following happen:

- the size classification changes
- the write scope expands materially beyond the approved plan
- the changed behavior or acceptance criteria change
- the UX direction changes in a user-visible way
- the performance characteristics or risk profile change materially
- the integration sequence changes enough to affect rollout or verification strategy

For minor clarifications that do not change approved scope or behavior, proceed and note the clarification in the final summary.

Examples of minor clarifications that do not require re-approval:

- choosing between two already-in-scope helper functions
- confirming the exact existing test file to extend
- adjusting local implementation order without changing behavior, scope, or verification strategy

Examples that do require re-approval:

- discovering another module must be changed outside the approved write scope
- realizing the accepted UX behavior needs a different user-visible flow
- learning that the approved acceptance criteria are insufficient or wrong
- introducing a new performance tradeoff, rollout step, or migration concern not covered by the approved plan

## Step 4: Review Within Budget

Before final verification, always review the implemented diff. Review is mandatory; subagent-based review is budgeted.

The review must cover:

- regressions and edge cases
- missing or stale tests
- unsynchronized representations
- evidence that the old behavior still exists elsewhere
- contradictions to the current understanding of the changed behavior
- repository pattern drift and unstated convention violations

Main agent checklist review is required for every task, including Small work. The main agent must explicitly check the review areas above before verification.

Post-implementation review budget:

- **Small / Low risk:** main agent checklist review only. Do not call this skipped review; record it as local review.
- **Small / Normal risk:** at most 1 reviewer subagent. Focus the reviewer on behavior regressions, stale assumptions, missing tests, or missing representations.
- **Medium:** 2 reviewers by default, or 1 reviewer plus main agent checklist review if concerns are tightly coupled.
- **Large / High risk:** 2 or more reviewers. Assign distinct ownership for behavior, tests, data, UX, performance, rollout, or other relevant risks.

When subagents are used, assign distinct review ownership. Examples:

- one reviewer checks behavior and edge cases while another checks tests and stale assumptions
- one reviewer checks one subsystem while another checks another subsystem
- one reviewer focuses on contradictions and leftover old behavior while another focuses on missing verification

When no subagent is used, briefly record the main agent checklist findings so the review is visible rather than implied.

## Step 5: Verify

Run the relevant checks for the affected area after review fixes are applied.

Treat completion as "no convincing contradiction found," not merely "tests passed."

## Step 6: Done

Summarize in this order:

- outcome and changed behavior shipped
- verification run
- review findings fixed or remaining risks
- review budget used and why it fit the size/risk classification
- final synchronization status of each representation
- representations checked and intentionally unchanged
- minor scope clarifications handled without re-approval, if any

Keep the final report concise. Do not reconstruct the original plan, list every inspected file, or propose a new plan unless execution stopped for re-approval.

## Rules

- Never implement without an approved plan
- Never create a new approval-ready plan inside `task-execute`
- Never turn pre-implementation confirmation into re-planning
- Never run `task-plan`-style subagent review before implementation starts
- Never regenerate an approval gate such as "if this plan is okay, I will implement it"
- Never skip post-implementation review
- Respect the approved subagent budget unless size/risk materially changes
- Never continue after a material plan change without re-approval
- No unrelated refactors or cleanup
- Keep tool usage specific and efficient
- Do not classify or reclassify by the raw number of files alone
- Prefer behavior-level reasoning over file-level reasoning when the same rule may be represented in multiple places
- In review, treat one-sided updates as a likely bug even when tests pass
- Assume there may be undiscovered representations until contradiction search is complete
- Prefer searching for leftover evidence of the old behavior over searching only for support of the new behavior
- Scale the workflow up or down if the scope changes; tell the user when you do

## Examples

Good:

- restate the approved plan in 2-3 sentences
- confirm the minimum necessary code location or existing test to edit
- start implementation immediately

Bad:

- use subagents to re-investigate the task even though an approved plan already exists
- rebuild and re-present an approval-ready plan
- hold implementation until a new approval gate is satisfied
