---
name: call-code-critic
description: "WHEN: the user wants a critical review by the `code-critic` agent. The skill gathers the agent's required Invocation Contract inputs (review target, intent, layer), dispatches the agent via the Agent tool, and drives the **address-then-re-review** loop until no actionable findings remain or the user explicitly defers what is left."
user-invocable: true
---

## Role

This skill is the **entry seam** between the user and the `code-critic` agent, **and it owns the review iteration loop**. Its responsibility is twofold:

1. Gather the three Invocation Contract inputs the agent requires, then dispatch the agent.
2. Drive the **address-then-re-review** loop after each dispatch, until the agent returns no actionable findings or the user explicitly defers what remains. A single invocation is **not** a complete review—it is a single iteration.

All review logic—Review Layering, the foundational lenses (High Cohesion / Loose Coupling, Open-Closed Principle, Design by Contract, Secure by Design), Test Smell as Design Signal, the choice between `critic-design-review` and `critic-implementation-review`—lives **inside the agent**. The skill never critiques. But the skill *does* own the cycle, because findings without follow-through are wasted output.

## Procedure

### 1. Gather the agent's required inputs

The agent's Invocation Contract requires four items. Three come from the user; the fourth (workspace root) comes from the host agent's own environment and **must not be left to the agent to infer**.

From the user (gather via `AskUserQuestion` if missing from the invocation):

- **Code under review**: file paths, directory, diff, PR number, or pasted code—each in identifiable scope
- **Intent of the change**: what the change is supposed to accomplish; for design review, the design intent and the constraints driving the shape; for implementation review, the contract / signature / invariants the implementation must satisfy
- **Review layer in scope**: `design` / `implementation` / `both` / `unspecified`

From the **host agent's own context** (do not ask the user):

- **Workspace root for persistence**: the absolute path of the Claude Code session's primary working directory. The host agent (the LLM dispatching this skill) knows this from its system context (e.g., the system prompt's "primary working directory" field, or `$HOME`-relative knowledge of the session). If unsure, the host may verify with `Bash`: `pwd` taken at the top level of the host's own session **before** any `cd` into a sub-project, but the host is responsible—not the agent. In a multi-project workspace, the user's intended workspace root may be an ancestor of the review target; the host must distinguish the two and pass the **ancestor**, not the review target.

  Resolve and validate this absolute path **once, in this skill, before launching the agent**. The agent has been observed to mis-resolve workspace root via `pwd`, `$CLAUDE_PROJECT_DIR`, or `git rev-parse --show-toplevel` and create `tmp/` inside a sub-project. The Invocation Contract therefore requires the caller (this skill, via the host agent) to supply the path explicitly; the agent will refuse the call if it is missing.

### 2. Launch `code-critic` for the initial iteration

Call the `Agent` tool with `subagent_type: code-critic`. Pass the four gathered items in this structure (headings match the agent's Invocation Contract terms verbatim):

```
## Code under review
<file paths / diff / PR number / pasted code, with identifiable scope>

## Intent of the change
<what the change accomplishes; for design review, the design intent and constraints;
 for implementation review, the contract / signature / invariants to satisfy>

## Review layer in scope
design | implementation | both | unspecified

## Workspace root for persistence
<absolute path of the Claude Code session's primary working directory; the directory under which `tmp/code-critic-<branch-slug>-<rev>.md` will be written>
```

Pass a short, identifying `description` such as `Critical review via code-critic`. You may also pass a `name` such as `code-critic-<branch-slug>` so the agent is addressable by stable name in addition to the runtime-assigned ID.

**Capture the agent's ID** from the response. The runtime emits it both as `agentId: <id>` and as a hint like `SendMessage with to: '<id>' to continue this agent`. This ID is the handle for every subsequent iteration in this loop—do not lose it. The conversation context inside that agent run is the one you must resume on every re-review.

### 3. Drive the address-then-re-review loop (mandatory)

The agent's first response is **never the end**. Iterate the cycle below until the termination condition is met. The loop is **non-negotiable**: a review that is not acted upon is the same as no review.

For each iteration:

1. **Surface the agent's findings to the user verbatim** (Output Contract: `Issue / Root Cause / Impact / Fix`). The agent does not emit Priority Assessment or severity tags—**every reported finding is a blocker by virtue of being reported**. Do not introduce a downstream ranking, do not summarize "the important ones", do not soften any item. Note the persisted file path returned by the agent (`Review saved to: <path>`).
2. **Triage with the user** for each finding using `AskUserQuestion`. Triage is binary because the upstream contract is binary:
   - **Address**: apply the structural fix the agent prescribed (not just a textual patch—the `Fix` text is the structural target). Commit if appropriate.
   - **Reject (with reason)**: only when the user provides a domain reason that makes the finding non-applicable (e.g., the agent misread the constraint, the code path is dead, the requirement has changed). Record the reasoning so the next review reconciles correctly and does not re-raise it. Rejection requires an explicit reason; "later" or "minor" is **not** a reason and is not allowed—the upstream contract guarantees there are no "minor" findings.
3. **Apply the addressed fixes** to the code under review.
4. **Re-review via `SendMessage` against the captured agent ID**—do **not** re-launch a fresh `Agent` for each iteration. Resuming the same agent keeps the prior findings, the persisted file paths, and the in-conversation discussion in its working memory; re-launching loses all of that and forces the agent to rebuild context from the persisted file alone. Continuity of the agent's working memory is the value of holding the ID.

   Call `SendMessage` with `to: '<captured agent ID>'`. The message body focuses on the **delta**, since the agent already knows what was reviewed and what it raised:

   ```
   ## Iteration N+1: addresses findings from <prior file path>

   ## Workspace root for persistence
   <same absolute path passed at initial dispatch — re-sent every iteration so the agent never re-infers it>

   ## Changes since prior review
   <what was changed in the code; diff, paths, or summary referencing the prior issues>

   ## User decisions on prior findings
   - <prior issue title> → Address (fix applied as: <one-line summary>)
   - <prior issue title> → Reject (reason: <user-supplied domain reason; agent should not re-raise>)
   ```

   The agent runs another iteration—reconciles via Prior Review Awareness, applies Core Principles to the delta, and persists a fresh `code-critic-<branch-slug>-<rev+1>.md`. Surface the new findings (return to step 1 of this loop).

   **Fallback**: if the agent ID is unavailable (e.g., the runtime no longer accepts `SendMessage` to it), launch a fresh `Agent` as in step 2 of this Procedure, but expand the `Intent of the change` to include the iteration number and the prior file path. Prior Review Awareness will still reconcile via the persisted files, but the in-conversation memory of the prior pass is lost—accept this only as a fallback.

**Termination condition** (loop exits only when **both** hold):

- The agent returns **no new findings** in the current iteration.
- Every persisted (carried-over) finding from prior iterations has a recorded outcome (Address with fix applied, or Reject with explicit user-supplied domain reason).

There is no "deferred" state and no "lower-priority items left out of scope" termination—the upstream contract guarantees every reported finding is a blocker, so the loop exits only when all of them are resolved or explicitly rejected.

When the loop exits, summarize the final state to the user: which iterations ran, which findings were addressed in code, which were rejected (with reasons), and the path of the latest persisted review.

## Constraints

- The skill **gathers, dispatches, and drives the iteration loop**. It does not critique, route between design/implementation, or shape the agent's output.
- Best-effort precondition gather at the seam; the **authoritative precondition enforcement is the agent's**. If a malformed call slips through, the agent's Invocation Contract will refuse it.
- A single invocation is **not** a complete review. Exiting after one pass without a recorded user decision on the findings is a contract violation of this skill.
- The user owns the Address / Defer / Reject decision for each finding. Do not auto-defer or auto-reject; ask via `AskUserQuestion`.
- Apply structural fixes (per the agent's `Fix` text), not surface-level textual patches that leave the root cause intact.
- **Capture the initial agent ID** and use `SendMessage` to that ID for every re-review in the loop. Re-launching a fresh `Agent` per iteration discards the agent's working memory of the prior pass and is wasteful; only fall back to a fresh launch if the captured ID is no longer addressable.
