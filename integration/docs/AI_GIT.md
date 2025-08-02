# General change rules

Do not change files in `//third_party` without user's explicit permission.

## General git commit rules

Any git commit created by Gemini must contain this note as the last line in the
commit message in addition to any commit summaries added:

```
This commit has been created by an automated coding assistant,
with human supervision.
```

## Create pull request

Use the `gh` utility to create the pull request.

Rebase the branch `main` from remote `origin/main`.

Create the pull request, using as description a summary of all the commits
between `origin/main` and the top of this branch.
