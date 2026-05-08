---
name: call-code-critic
description: "WHEN: the user wants a critical review by the `code-critic` agent. The skill gathers the agent's required Invocation Contract inputs (review target, intent, layer), dispatches the agent via the Agent tool, and drives the **address-then-re-review** loop until no actionable findings remain or the user explicitly defers what is left."
user-invocable: true
---

## Role

Entry seam between the user and the `code-critic` agent, **and owner of the review iteration loop**:

1. Gather the four Invocation Contract inputs and dispatch the agent.
2. Drive the **address-then-re-review** loop until the agent returns no actionable findings or the user explicitly defers what remains. A single invocation is **not** a complete review.

All review logic—Review Layering, foundational lenses, the choice between `critic-design-review` and `critic-implementation-review`—lives **inside the agent**. The skill never critiques. But it owns the cycle—findings without follow-through are wasted output.

## Procedure

### 1. Gather the agent's required inputs

From the user (via `AskUserQuestion` if missing):

- **Code under review**: file paths, directory, diff, PR number, or pasted code—each in identifiable scope
- **Intent of the change**: what it accomplishes; for design review, the design intent and constraints; for implementation review, the contract / signature / invariants to satisfy
- **Review layer in scope**: `design` / `implementation` / `both` / `unspecified`

From the **host agent's own context** (do not ask the user):

- **Workspace root for persistence**: absolute path of the Claude Code session's primary working directory. The host agent knows this from its system context. In a multi-project workspace, the user's intended workspace root may be an ancestor of the review target; pass the **ancestor**, not the review target. Resolve and validate this absolute path **once, in this skill, before launching the agent**. The Invocation Contract requires the caller to supply the path explicitly; the agent refuses if it is missing.

### 2. Launch `code-critic` for the initial iteration

Call the `Agent` tool with `subagent_type: code-critic`. Pass the four items in this structure:

```
## Code under review
<file paths / diff / PR number / pasted code, with identifiable scope>

## Intent of the change
<what the change accomplishes; for design review, the design intent and constraints;
 for implementation review, the contract / signature / invariants to satisfy>

## Review layer in scope
design | implementation | both | unspecified

## Workspace root for persistence
<absolute path of the Claude Code session's primary working directory>
```

Pass `description: Critical review via code-critic` and optionally `name: code-critic-<branch-slug>`.

**Capture the agent's ID** from the response (`agentId: <id>` / `SendMessage with to: '<id>'`). This ID is the handle for every subsequent iteration—do not lose it.

### 3. Drive the address-then-re-review loop (mandatory)

The agent's first response is **never the end**. Iterate until termination.

For each iteration:

1. **Surface the agent's findings to the user verbatim** (`Issue / Root Cause / Impact / Fix`). Every reported finding is a blocker—do not summarize, rank, or soften. Note the persisted file path (`Review saved to: <path>`).
2. **Triage with the user** for each finding via `AskUserQuestion`. Triage is binary:
   - **Address**: apply the structural fix the agent prescribed. Commit if appropriate.
   - **Reject (with reason)**: only when the user provides a domain reason that makes the finding non-applicable. "Later" or "minor" is **not** a reason.
3. **Apply the addressed fixes**.
4. **Re-review via `SendMessage` against the captured agent ID**—do **not** re-launch a fresh `Agent`. Resuming preserves the agent's working memory of the prior pass. Message body focuses on the delta:

   ```
   ## Iteration N+1: addresses findings from <prior file path>

   ## Workspace root for persistence
   <same absolute path passed at initial dispatch>

   ## Changes since prior review
   <diff, paths, or summary referencing the prior issues>

   ## User decisions on prior findings
   - <prior issue title> → Address (fix applied as: <one-line summary>)
   - <prior issue title> → Reject (reason: <user-supplied domain reason>)
   ```

   The agent reconciles via Prior Review Awareness against the latest persisted file, applies its principles to the delta, and persists `code-critic-<branch-slug>-<rev+1>.md`.

   **Fallback**: if the agent ID is no longer addressable, launch a fresh `Agent` as in step 2, expanding `Intent of the change` with the iteration number and the prior file path. Prior Review Awareness still reconciles via the persisted file; in-conversation memory is lost—accept only as fallback.

**Termination condition** (loop exits only when **both** hold):

- The agent returns **no new findings** in the current iteration.
- Every persisted (carried-over) finding has a recorded outcome (Address with fix applied, or Reject with explicit user-supplied reason).

There is no "deferred" state. The upstream contract guarantees every reported finding is a blocker.

When the loop exits, summarize the final state to the user: which iterations ran, which findings were addressed, which were rejected (with reasons), and the path of the latest persisted review.

## Constraints

- The skill **gathers, dispatches, and drives the iteration loop**. It does not critique or shape the agent's output.
- A single invocation is **not** a complete review. Exiting after one pass without a recorded user decision is a contract violation.
- The user owns the Address / Reject decision for each finding. Do not auto-defer or auto-reject.
- Apply structural fixes (per the agent's `Fix` text), not surface-level textual patches.
- **Capture the initial agent ID** and use `SendMessage` for every re-review. Re-launching per iteration is wasteful; only fall back if the captured ID is no longer addressable.
