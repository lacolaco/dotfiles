---
description: Analyze current changes and suggest supplementary improvements
---

Analyze current git changes and provide improvement suggestions.

## Phase 1: State Analysis

Gather current working state using:
- `git status`: List of changed files
- `git diff`: Details of unstaged changes
- `git diff --cached`: Staged changes
- `git log -5 --oneline`: Recent commit history

## Phase 2: Intent Understanding

Infer from changes:
- Type of task (feature addition / bug fix / refactoring / etc.)
- Purpose and background of the changes

Verify hypothesis by checking:
- Related existing code and patterns
- Dependencies and affected files
- Project conventions (from CLAUDE.md, configs, etc.)

## Phase 3: Improvement Proposals

Provide suggestions from these perspectives:

### Proposal Categories
1. **Comments**: Explanatory comments for complex logic
2. **Documentation**: README, API docs, type definitions
3. **Tests**: Unit tests, integration tests
4. **Refactoring**: Code quality improvements
5. **Security**: Permissions, secrets exposure, input validation
6. **Consistency**: Alignment with existing patterns and conventions

### Output Format
```
## Improvement Proposals

**1. [Category] Title**
- Target: [file path]
- Reason: [why this improvement is needed]
- Content: [specific changes]

**2. [Category] Title**
...

---
Specify proposals to execute by number (e.g., 1,3 / all / none)
```

## Phase 4: Execution

Execute the proposals specified by user.
