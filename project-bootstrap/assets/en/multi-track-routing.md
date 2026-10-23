## Working context

- This project shares one repository, source materials, and reusable tools across explicitly separated task tracks. Shared constraints remain in this root file; track `RULES.md` files contain only track-specific requirements.
- At task start, read `context/ACTIVE.md`, then the selected track's `RULES.md`, `STATE.md`, and `MEMORY.md` when present. Also read root `MEMORY.md` if it retains useful shared lessons. Do not routinely load every track's context.
- Follow an explicit user request to resume/switch a track and update the global active-track file. Otherwise retain the active track. Looking up another track's existing information or doing repository-wide maintenance does not automatically switch it.
- `context/ACTIVE.md` records the selected track and its entry points, not phase progress or a switch log. Phase, completed facts/evidence, blockers, and executable next steps belong in `context/<track-id>/STATE.md`.
- Keep `MEMORY.md` for lasting decisions, reasons, and reusable lessons with sources/commit references. Create it when useful; consolidate at milestones, direction changes, or when repetitive/outdated. Aim for about one page; use Git for detailed history, without `HISTORY.md`.
- After substantive work, update only changed information in the affected tracks. Keep shared results in one place and record the adopted path, version, and purpose where needed. Another track's unassessed result is an input to evaluate, not automatically a completed milestone.
- Track work normally runs sequentially. If the user runs concurrent chats, each chat's explicit track takes precedence; avoid racing global-state writes and simultaneous edits to the same file.
- Read-only questions do not update rules, active track, state, memory, navigation, or dates and do not create reports/check files/empty commits. Explicit switching or recording a decision is a state change, scoped to that request.
