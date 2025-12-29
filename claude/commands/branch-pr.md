---
description: Create a branch and a PR from current changes
allowed-tools: "Bash(git:*), Bash(gh:*) Bash(glab:*)"
---

## Context

- Git status: !`git status`
- Current branch: !`git rev-parse --abbrev-ref HEAD`
- Differences: !`git diff HEAD`

## Your task

Based on the context above, follow these steps:

1. **Safety check**: 
   - If currently on `main` branch with uncommitted changes, create a new branch first to avoid committing directly to main
   - Suggest a descriptive branch name based on the changes shown in the diff (e.g., `feature/add-user-auth`, `fix/handle-null-errors`, `docs/update-readme`)

2. **Create branch** (if needed):
   ```bash
   git checkout -b <suggested-branch-name>
   ```

3. **Stage and commit changes**:
   - **IMPORTANT**: Check for repository-specific commit message rules first (look for CONTRIBUTING.md, .gitmessage, or project documentation)
   - If no specific rules exist, follow Conventional Commits format
   - Analyze the diff to suggest an appropriate commit message
   - **NOTE**: Do NOT include Claude Code co-author credits or AI tool references in commit messages
   - Examples:
     - `feat(auth): add user login functionality`
     - `fix(api): handle null response errors`
     - `docs: update installation instructions`
   ```bash
   git add .
   git commit -m "<suggested-commit-message>"
   ```

4. **Push branch**:
   ```bash
   git push origin <branch-name>
   ```

5. **Create pull request**:
   - Generate PR title and description based on the changes
   - **NOTE**: Use `glab` if the repository is on GitLab
   - **NOTE**: Do NOT include Claude Code co-author credits or AI tool references in PR titles or descriptions
   - Example:
   ```bash
   gh pr create --base main --title "<suggested-pr-title>" --body "<generated-description>"
   ```

## Conventional Commits Reference

**Use only if no repository-specific commit rules exist**

- **Types**: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `style`, `perf`
- **Scopes**: Use relevant area like `auth`, `api`, `ui`, `config`, `deps`
- **Format**: `type(scope): description`
