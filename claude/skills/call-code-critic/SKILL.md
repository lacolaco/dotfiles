---
name: call-code-critic
description: "WHEN: the user wants to invoke the `code-critic` agent for a critical review of current code, a PR, or specific files (`/call-code-critic`). INPUT: review target (paths / diff / PR number / pasted code) + intent of the change + review layer in scope (`design` / `implementation` / `both` / `unspecified`). OUTPUT: launches the `code-critic` agent via the Agent tool and surfaces its critical findings to the user verbatim, preserving structure and tone."
user-invocable: true
---

## Role

This skill is the **entry point** for invoking the `code-critic` agent. The agent declares an Invocation Contract whose precondition is sufficient input from the caller—review target, intent of the change, review layer in scope. This skill exists solely to satisfy that precondition and dispatch the agent.

All review logic—Review Layering, the foundational lenses (High Cohesion / Loose Coupling, Open-Closed Principle, Design by Contract, Secure by Design), Test Smell as Design Signal, the choice between `critic-design-review` and `critic-implementation-review`—lives **inside the agent**. This skill does not critique. It dispatches.

## Procedure

### 1. Verify the Invocation Contract precondition

The `code-critic` agent requires three inputs. If any are missing, **do not launch the agent.** Use `AskUserQuestion` to demand the missing items first; partial invocation will be refused by the agent's own Invocation Contract.

- **Review target**: file paths, directory, diff, PR number, or pasted code—each in identifiable scope
- **Intent of the change**: what the change is supposed to accomplish; for design review, the design intent and the constraints driving the shape; for implementation review, the contract / signature / invariants the implementation must satisfy
- **Layer in scope**: `design` / `implementation` / `both` / `unspecified` (when `unspecified`, the agent decides via Review Layering—if the change touches both layers, design review runs first)

Do not assume the agent will "figure out" missing inputs. Demanding them up front is the contract; bypassing it relocates a caller-side defect to the supplier.

### 2. Launch `code-critic` via the Agent tool

Call the `Agent` tool with `subagent_type: code-critic`. Embed the three precondition items in the prompt with this structure:

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

- The skill **only dispatches**. Do not generate critique content inside this skill.
- Do not launch the agent without the three precondition items satisfied. Partial invocation is refused by the agent.
- Do not paraphrase, summarize, or soften the agent's findings before presenting them.
- Do not pre-decide the review layer when it is genuinely unclear; pass `unspecified` and let the agent's Review Layering route correctly.
