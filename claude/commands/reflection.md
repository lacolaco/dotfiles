---
description: Kolb's experiential learning cycle for extracting reusable principles from session experience
---

Transform session experience into reusable principles through Kolb's Learning Cycle.

**Framework: Kolb's Experiential Learning Model**

Concrete Experience → Reflective Observation → Abstract Conceptualization → Active Experimentation

**Critical Constraint**: Phase 3 (Abstract Conceptualization) is MANDATORY.
No concrete implementation details may enter CLAUDE.md without abstraction.

**Output Language**: ALWAYS use the same language as the user's session (e.g., Japanese session → Japanese output).

---

## Phase 1: Concrete Experience

**Purpose**: Organize session logs as factual records. NO analysis or interpretation.

**Critical**: Focus ONLY on facts. NO analysis, interpretation, or reflection in this phase.

**Structure**: Record facts for each of the 3 axes.

**Output Format**:
```
## Phase 1: Concrete Experience

### Goal Achievement Facts
- What was requested: [User instruction/requirement]
- What was completed: [Completed task/feature]
- What was not completed: [Incomplete task/blocker]

### Efficiency Facts
- Actions executed: [Action performed]
- Time/attempts: [Duration/iteration count]
- Rework needed: [What had to be redone]
- Blockers encountered: [Blocker that stopped progress]

### User Satisfaction Facts
- User reactions: [Observed user response]
- Frustration points: [When/where user expressed frustration]
- Satisfaction points: [When/where user expressed satisfaction]
```

---

## Phase 2: Reflective Observation

**Purpose**: Analyze patterns and root causes from experience.

**Tasks**:
- 3-axis evaluation (Goal Achievement / Efficiency / User Satisfaction)
- Pattern recognition: What repeated?
- Root cause analysis: Why did it happen? (3 Whys)

**Output Format**:
```
## Phase 2: Reflective Observation

### Goal Achievement: 7/10
- Keep: [What worked well and should continue]
  - Success factor: [Why did this work well?]
- Problem: [Issues and challenges]
  - Root cause: [Why? → Why? → Why?]

### Efficiency: 6/10
- Keep: [What worked well and should continue]
  - Success factor: [Why did this work well?]
- Problem: [Issues and challenges]
  - Root cause: [Why? → Why? → Why?]

### User Satisfaction: 8/10
- Keep: [What worked well and should continue]
  - Success factor: [Why did this work well?]
- Problem: [Issues and challenges]
  - Root cause: [Why? → Why? → Why?]

### Pattern Recognition
What repeated during this session:
- [Repetition 1]
- [Repetition 2]
```

---

## Phase 3: Abstract Conceptualization

**Purpose**: Extract reusable principles from concrete experience.

🚨 **CRITICAL: Abstraction Quality Gate** 🚨

Every principle MUST pass this checklist:

```
□ Removed concrete implementation details (function names, file names, URLs, etc.)
□ Specified "Apply when" conditions (when to apply)
□ Described as reusable principle (applicable to other projects)
□ Checked for duplication/conflict with existing CLAUDE.md rules
□ Verified applicability even in counter-examples
```

**Tasks**:
1. Create Concrete→Abstract Transformation Table
2. Extract reusable principles
3. Verify abstraction quality
4. Check integration with existing CLAUDE.md rules

**Output Format**:
```
## Phase 3: Abstract Conceptualization

### Extracted Principles

#### [Principle Name 1]
**Apply when**: [Conditions/Triggers]
- [Principle content 1]
- [Principle content 2]

#### [Principle Name 2]
**Apply when**: [Conditions/Triggers]
- [Principle content 1]
- [Principle content 2]
```

---

## Phase 4: Active Experimentation

**Purpose**: Propose practical improvements to increase success reproducibility and prevent failure recurrence.

**Improvement Types**:
- Memory file (CLAUDE.md) updates: Add/modify/delete context and rules
- External scripts: Automate deterministic solutions
- Lint rules: Enforce patterns automatically
- Other tools: Any external mechanisms to prevent recurrence

**Critical**: Present all improvements as numbered proposals. User approves by specifying proposal numbers.

**Output Format**:
```
## Phase 4: Active Experimentation

### Improvement Proposals

**1. [Type - e.g., CLAUDE.md Update]**
- Problem addressed: [Specific problem from Phase 2]
- Solution: [Specific improvement]
- Implementation:
  ```markdown
  [Exact change to make]
  ```

**2. [Type - e.g., External Script]**
- Problem addressed: [Specific problem from Phase 2]
- Solution: [Script/automation to create]
- Implementation:
  ```bash
  [Script content or command]
  ```

**3. [Type - e.g., Lint Rule]**
- Problem addressed: [Specific problem from Phase 2]
- Solution: [Lint rule to add]
- Implementation:
  ```json
  [Rule configuration]
  ```

---

**Approve proposals** (specify numbers, e.g., "1,3" or "all" or "none"):
```

---

## Guidelines

- **Thorough Abstraction**: Never add concrete implementation details to CLAUDE.md
- **Reusability**: Formulate in a way applicable to other projects and contexts
- **Consistency with Existing Rules**: Align with existing CLAUDE.md format
- **Verifiability**: Make principles verifiable in next session

---

## Anti-patterns

❌ **Bad**: Verify email validation before calling `UserService.createUser()`
✅ **Good**:
```markdown
### Input Validation Protocol
**Apply when**: Processing user input in any function/endpoint
- Verify validation logic executes beforehand
- Verify error handling on failure
```

❌ **Bad**: `POST /api/users` must return 201
✅ **Good**:
```markdown
### HTTP Status Code Consistency
**Apply when**: RESTful API design/implementation
- Use 201 for successful resource creation
- Verify idempotency and status code correspondence
```
