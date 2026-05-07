---
name: call-code-critic
description: "WHEN: the user wants a critical review by the `code-critic` agent (`/call-code-critic`). OUTPUT: gathers the agent's required inputs from the user (review target, intent, layer), launches `code-critic` via the Agent tool, and surfaces the agent's critical findings to the user verbatim—preserving structure and tone."
user-invocable: true
---

## Role

This skill is the **entry point** for invoking the `code-critic` agent. The agent declares an Invocation Contract whose precondition is sufficient input from the caller. **The skill's job is to gather those inputs from the user and hand them to the agent.** It does not critique.

All review logic—Review Layering, the foundational lenses (High Cohesion / Loose Coupling, Open-Closed Principle, Design by Contract, Secure by Design), Test Smell as Design Signal, the choice between `critic-design-review` and `critic-implementation-review`—lives **inside the agent**.

## Procedure

### 1. Gather the agent's required inputs from the user

The `code-critic` agent's Invocation Contract requires three items. If the user's invocation already supplies all three (e.g., "review the diff on this branch as a design change for the new auth module"), proceed. If anything is missing, demand it via `AskUserQuestion` before launching the agent—do not guess, do not let the agent fill in gaps. Bypassing this relocates a caller-side defect to the supplier.

- **Review target**: file paths, directory, diff, PR number, or pasted code—each in identifiable scope
- **Intent of the change**: what the change is supposed to accomplish; for design review, the design intent and the constraints driving the shape; for implementation review, the contract / signature / invariants the implementation must satisfy
- **Layer in scope**: `design` / `implementation` / `both` / `unspecified` (when `unspecified`, the agent decides via Review Layering—if the change touches both layers, design review runs first)

When in doubt about layer, pass `unspecified` rather than guessing—the agent's Review Layering will route correctly.

### 2. Launch `code-critic` via the Agent tool

Call the `Agent` tool with `subagent_type: code-critic`. Pass the three gathered items in the prompt with this structure:

```
## Review target
<file paths / diff / PR number / pasted code, with identifiable scope>

## Intent of the change
<what the change accomplishes; for design review, the design intent and constraints;
 for implementation review, the contract / signature / invariants to satisfy>

## Layer in scope
design | implementation | both | unspecified
```

Pass a short, identifying `description` such as `Critical review via code-critic`.

### 3. Surface the agent's output verbatim

The agent returns critical findings in the form `Issue` / `Root Cause` / `Impact` / `Fix`, ending with a `Priority Assessment`. Present this output **as-is**: no summarization, no cherry-picking, no tone softening. The agent's brutal-honest register is the value—do not dilute it.

## Constraints

- The skill **only gathers inputs and dispatches**. Do not generate critique content inside this skill.
- Do not launch the agent without the three precondition items satisfied. Partial invocation is refused by the agent.
- Do not paraphrase, summarize, or soften the agent's findings before presenting them.
- Do not pre-decide the review layer when it is genuinely unclear; pass `unspecified` and let the agent's Review Layering route correctly.
