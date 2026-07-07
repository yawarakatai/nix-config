''
  # Global Agent Instructions

  ## General

  - Keep changes scoped to the user's request.
  - Prefer small incremental changes over large rewrites.
  - Understand nearby code and existing design before editing.
  - If the task completes successfully and there are changes, always ask whether to commit them.

  ## Environment

  - Use the project's existing tools, languages, conventions, and package manager.
  - Use Nix flakes when the project provides them.
  - Prefer `nix develop -c <command>` for commands that need the dev environment.

  ## Code Quality

  - Prefer clear, readable, self-documenting code.
  - Write code comments in English.
  - Avoid premature abstraction.
  - Prefer small, focused functions with a single responsibility.
  - Extract helpers when they improve readability, testability, or remove repeated non-trivial logic.
  - Avoid excessive fragmentation into tiny helpers.
  - Keep core logic as pure as practical and keep I/O at the edges.
  - Prefer explicit error handling over panics for recoverable errors.

  ## Documentation

  - Update documentation when changing user-visible behavior, CLI flags, config formats, public APIs, architecture, setup steps, or examples.
  - Keep README, examples, and command help consistent with the implementation.
  - Remove or update stale documentation instead of adding contradictory notes.

  ## Dependencies

  - Do not add new dependencies unless clearly justified.
  - Prefer the standard library or existing project dependencies when practical.
  - Ask before adding, replacing, or major-upgrading dependencies.
  - Ask before updating lockfiles unless explicitly requested.

  ## Validation

  - Add or update tests for behavior changes, bug fixes, parsers, protocols, and edge cases.
  - Run relevant tests, linters and formatters after changes.
  - If validation cannot be run, report the exact command that was skipped and why.

  ## Safety

  - Do not perform destructive, privileged, secret-related, or workspace-external actions unless explicitly requested.
  - Do not overwrite, revert, reformat, or move unrelated user changes.
''
