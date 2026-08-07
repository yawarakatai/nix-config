''
  # Global Agent Instructions

  ## General

  - Keep changes scoped to the user's request.
  - Understand relevant existing code and design before editing.
  - Prefer small, focused changes over unnecessary rewrites.
  - Follow the project's existing tools, conventions, and architecture.
  - Do not modify unrelated user changes.

  ## Dependencies

  - Prefer existing dependencies and the standard library when practical.
  - Do not add, replace, or major-upgrade dependencies unless necessary for the task or explicitly requested.
  - Do not update lockfiles unnecessarily.

  ## Quality

  - Prefer clear, readable code and avoid premature abstraction.
  - Keep I/O and side effects localized when practical.
  - Handle recoverable errors explicitly rather than panicking.
  - Update relevant documentation when user-facing behavior or interfaces change.

  ## Validation

  - Add or update tests when behavior changes warrant them.
  - Run relevant tests, linters, and formatters after changes.
  - If validation cannot be run, report what was skipped and why.

  ## Safety

  - Do not perform destructive, privileged, secret-related, or workspace-external actions unless explicitly requested.
  - Do not overwrite, revert, reformat, or move unrelated user changes.

''
