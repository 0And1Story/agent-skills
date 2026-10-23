# Migrate a single project into multiple task tracks

Read this guide only for an explicit track-separation request, including one made during initialization. Preserve the existing repository, branch, shared materials, tools, and artifact paths by default. Track separation is a context migration, not a reason to create repositories, long-lived branches, or worktrees.

## Establish the tracks

Use the user-confirmed track names and purposes; choose stable folder identifiers such as `research` or `product`. Do not infer that every deliverable is a separate track. Determine the current track from the user's instruction or reliable existing state. If it cannot be established, ask for the active track while continuing history inspection and classification. Do not decide solely from the most recently modified file.

Select the requested language, retaining the language of existing unaffected materials. Use [English routing](../assets/en/multi-track-routing.md) or [Chinese routing](../assets/zh-CN/multi-track-routing.md) for the replacement working-context section. For other languages, translate the English fragment.

## Recover before reorganizing

1. Inspect Git status, current rules, state/memory if present, README, and the artifacts relevant to the proposed tracks. Preserve unrelated working changes. If migration inputs are uncommitted, account for them explicitly; do not treat HEAD as their latest version or commit unrelated edits simply to make a snapshot.
2. Locate transitions in Git history. Read older `AGENTS.md`, `STATE.md`, README, and actual deliverables around each transition. Rules that changed when one track took over may contain the missing previous track's scope and stopping point.
3. Corroborate progress with original reports, source files, archived evidence, check records, and relevant diffs. Commit subjects alone do not prove implementation, testing, submission, or acceptance.
4. For each track, extract completed facts and evidence, unfinished work, standing decisions, blockers, and the next executable action. Record the historical cutoff/source commit and today's recovery date separately. Label reconstructed next steps as suggestions when they were not previously agreed.
5. If history is missing or incomplete, state the gap and recover what the files support. Do not fabricate lost progress, assume a new track was never worked on, or turn later shared material into earlier completed work.

Useful history queries, replacing example paths and commit markers with actual values:

```text
git log --date=short --format="%h %ad %s" -- AGENTS.md STATE.md MEMORY.md README.md
git log --since="YYYY-MM-DD" --until="YYYY-MM-DD" --oneline -- path/to/artifact
git show <commit>:AGENTS.md
git show <commit>:README.md
git show <commit> -- path/to/artifact
git diff <before> <after> -- AGENTS.md path/to/artifact
```

Use history from the current branch first; inspect other branches only when they are relevant. Do not reset, checkout over local changes, rewrite history, or restore a historical `AGENTS.md` wholesale as current policy.

## Classify information by ownership

| Information | Destination |
|---|---|
| Constraints/rules applicable across tracks | Root `AGENTS.md` |
| Selected track and entry points | `context/ACTIVE.md` |
| A track's distinct goals, requirements, and editing boundaries | `context/<track-id>/RULES.md` |
| Current progress, evidence, blockers, and next steps | `context/<track-id>/STATE.md` |
| Lasting track-specific decisions, reasons, lessons, and sources | `context/<track-id>/MEMORY.md`, when useful |
| Useful lasting shared lessons already in root memory | Concise root `MEMORY.md`, if needed; shared rules still belong in `AGENTS.md` |
| Artifact navigation | Existing root `README.md` |
| Detailed chronology and superseded snapshots | Existing Git history |

Distinguish a permanent rule from a single-task instruction. Preserve past authorizations as historical records with their object and scope, not universal permission for later edits. Do not move an identical shared rule into every track merely because both use it.

## Apply a minimal migration

- Keep the root rules and existing project-specific invariants. Replace the single-track working-context section with the selected routing fragment and repair other stale single-track path references, adapted to actual paths. Do not replace the entire `AGENTS.md` with a generic template or append conflicting single/multiple-track loaders.
- Create `context/ACTIVE.md` with the active identifier, its rule/state/memory entry points as applicable, and necessary selection/recovery context. Keep phase progress elsewhere and omit switch history.
- For each confirmed track, create concise `RULES.md` and `STATE.md`. Create `MEMORY.md` only when there is useful content; consolidate decisions rather than copying entire conversations or old rules. A new unused track should explicitly have no completed work, not fabricated milestones.
- Keep common artifacts at their current paths. Each track records the adopted artifact path, relevant version/commit, and purpose when needed. Distinguish planned reuse from assessed/adopted results; shared evidence does not automatically satisfy both tracks' acceptance criteria.
- Remove stale progress from root `AGENTS.md`. Migrate relevant root `STATE.md` and track-specific memory entries after extracting their ownership. Preserve historical versions in Git. Repair incoming links; if a root state pointer must remain for compatibility, make it a short navigation pointer, not another authoritative progress snapshot. Retain root memory only for distinct useful shared lessons and include it in routing when it exists.
- Update root README with track entry points and a short history-query hint. Do not duplicate full progress summaries there. During ordinary work, no further skill invocation is required to switch tracks or maintain these files.

## Verify the migration

- Trace significant recovered claims to file evidence or commits. Plans remain plans; model examples, school submission, release, or publication are not complete unless supported.
- Check that shared constraints remain at the root, only the selected track is routinely loaded, and a read-only question about another track neither switches global state nor writes files.
- Explicitly asking to continue/switch a track updates `ACTIVE.md`; unspecified substantive work follows it. Repository-wide maintenance does not arbitrarily change it. If concurrent chats are later used, their explicit track choices take precedence and competing writes must be avoided.
- Check links, removal of duplicate authoritative state, preservation of original/annotated/submitted artifacts, and the requested language. Do not recompile artifacts just because their context moved.
- Review and commit only relevant migration files under the user's/repository's local Git policy. A subject such as `shared: separate project task tracks` supports later filtering. Do not push or rewrite historical commits.
- Briefly report active track, entry points, recovery cutoff/evidence, and any genuine gaps. Do not create a migration report or `HISTORY.md` unless a separate report was explicitly requested.
