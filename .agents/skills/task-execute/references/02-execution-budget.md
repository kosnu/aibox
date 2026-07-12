# Execution Budget

Separate what the main agent should do locally from what can be delegated safely in parallel.

## Main Agent Responsibilities

The main agent owns:

- critical-path implementation
- integration of delegated work
- synchronization across representations
- final review judgment
- verification and final report

## Delegation Rules

Use subagents only when there are independent tasks with disjoint or minimally coupled ownership and the approved size/risk budget allows it.

- Prefer `worker` subagents for bounded implementation tasks.
- Prefer `explorer` subagents for targeted read-only questions that unblock safe edits.
- Define ownership clearly when delegating code changes, including files or modules.
- Tell workers they are not alone in the codebase and must not revert others' changes.
- Keep the main agent focused on integration and final verification.

Do not use subagents to rebuild an approval-ready plan, perform `$task-plan`-style review before implementation, expand scope into new representation categories, or generate a fresh approval gate.

## Implementation Budget

- **Small:** main agent implements; no worker subagents.
- **Medium:** use at most 1 worker when ownership is clearly separated.
- **Large:** use multiple workers only when each has disjoint ownership and integration remains controlled.

If execution stays local, briefly record the main-agent checks and why delegation would not reduce risk or latency.

## Delegation Contract

Give each subagent one bounded task, explicit owned files or modules, required evidence, and a stop condition.

Read-only explorers return:

```text
question
findings[]
evidence[{path_or_url, line_or_id, reason}]
unresolved[]
stop_reason
```

Workers return changed paths, behavior implemented, verification run, and unresolved risks. Allow at most one retry for missing required evidence or an incomplete handoff. The main agent verifies material results, does not repeat completed work, integrates changes, and owns final review and verification.
