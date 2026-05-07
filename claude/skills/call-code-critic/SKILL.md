---
name: call-code-critic
description: "WHEN: the user wants a critical review by the `code-critic` agent. The skill gathers the agent's required Invocation Contract inputs (review target, intent, layer) from the user and dispatches the agent via the Agent tool."
user-invocable: true
---

## Role

This skill is the **entry seam** between the user and the `code-critic` agent. Its responsibility is narrow: gather the three Invocation Contract inputs the agent requires, then dispatch the agent. Nothing more.

All review logic—Review Layering, the foundational lenses (High Cohesion / Loose Coupling, Open-Closed Principle, Design by Contract, Secure by Design), Test Smell as Design Signal, the choice between `critic-design-review` and `critic-implementation-review`—lives **inside the agent**. The agent owns both its Invocation Contract (input shape) and its output contract (findings shape and the verbatim-surface rule). The skill only feeds it correctly-shaped input.

## Procedure

### 1. Gather the agent's required inputs from the user

The agent's Invocation Contract requires three items. If the user's invocation already supplies them all (e.g., "review the diff on this branch as a design change for the new auth module"), proceed. If anything is missing, gather it via `AskUserQuestion` before launching—best-effort fill at the entry seam so the agent does not have to refuse and round-trip:

- **Code under review**: file paths, directory, diff, PR number, or pasted code—each in identifiable scope
- **Intent of the change**: what the change is supposed to accomplish; for design review, the design intent and the constraints driving the shape; for implementation review, the contract / signature / invariants the implementation must satisfy
- **Review layer in scope**: `design` / `implementation` / `both` / `unspecified`

### 2. Launch `code-critic` via the Agent tool

Call the `Agent` tool with `subagent_type: code-critic`. Pass the three gathered items in this structure (headings match the agent's Invocation Contract terms verbatim):

```
## Code under review
<file paths / diff / PR number / pasted code, with identifiable scope>

## Intent of the change
<what the change accomplishes; for design review, the design intent and constraints;
 for implementation review, the contract / signature / invariants to satisfy>

## Review layer in scope
design | implementation | both | unspecified
```

Pass a short, identifying `description` such as `Critical review via code-critic`.

## Constraints

- The skill **only gathers and dispatches**. It does not critique, route between design/implementation, or shape the agent's output.
- Best-effort gather at the seam; the **authoritative precondition enforcement is the agent's**. If a malformed call slips through, the agent's Invocation Contract will refuse it.
