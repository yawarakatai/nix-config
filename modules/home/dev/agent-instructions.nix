''
  # Global Agent Instructions

  ## General

  - Keep changes scoped to the user's request.
  - Understand relevant existing code and design before editing.
  - Prefer small, focused changes over unnecessary rewrites.
  - Follow the project's existing tools, conventions, and architecture.

  ## Dependencies

  - Prefer existing dependencies and the standard library when practical.
  - Do not add, replace, or major-upgrade dependencies unless necessary for the task or explicitly requested.
  - Do not update lockfiles unnecessarily.

  ## Quality

  - Follow YAGNI and KISS: implement only what is needed, using the simplest design that satisfies the current requirements.
  - Prefer a little duplication over premature or incorrect abstraction.
  - Handle recoverable errors explicitly rather than panicking.
  - Comments should explain why, not what.

  ## Git / Commits

  - Use Conventional Commits (`feat: ...`, `fix: ...`, etc.) with concise English descriptions.
  - Commit completed task changes after required validation passes, unless the user asks otherwise.
  - Include only current-task changes; ask if validation is incomplete or pre-existing changes cannot be safely separated.
  - Never commit plaintext secrets or private keys. Do not push or rewrite existing commits unless explicitly requested.
  - Report the commit hash and a brief summary.

  ## Validation

  - Add or update tests when behavior changes warrant them.
  - Run relevant tests, linters, and formatters after changes.
  - If validation cannot be run, report what was skipped and why.

  ## Safety

  - Do not perform destructive, privileged, secret-related, or workspace-external actions unless explicitly requested.
  - Do not overwrite, revert, reformat, or move unrelated user changes.

''
