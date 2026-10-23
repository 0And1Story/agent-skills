---
name: project-bootstrap
description: "Explicitly initialize a new or early-stage project with Git and durable working rules, or migrate an existing project from one task track to multiple tracks. Use only when the user invokes this skill for setup or track separation; never for routine work in an established project."
---

# Project Bootstrap

This is a one-time setup and migration skill. Its output is ordinary project guidance that remains usable without invoking this skill again.

## Invocation boundary

- Run only on an explicit user invocation for project initialization or task-track separation. Multiple goals, missing rules, a new chat, or an ongoing task are not triggers.
- Default to **one task track**. Do not create `context/ACTIVE.md`, track folders, or routing rules unless the user explicitly requests separation.
- For an invocation that only asks about the skill or existing information, answer without changing files or state. If invoked for routine coding, research, writing, or progress updates, explain the narrow scope and follow the existing project guidance without applying setup again.
- Do not install the skill, change global agent settings, or add instructions to reinvoke it during normal work.

## Choose the mode and language

- **Initialize:** establish a new project or complete an explicitly requested early setup. An empty folder is valid. Existing files must be preserved and compatible rules merged rather than reset.
- **Separate tracks:** migrate an existing project only on explicit request. Read [the migration guide](references/multi-track-migration.md) for this mode; do not load it for ordinary single-track setup.
- Write generated project rules, state, memory, and navigation in **English by default**. Honor an explicitly requested output language. Read only the relevant template: [English AGENTS](assets/en/AGENTS.md.template) or [Simplified Chinese AGENTS](assets/zh-CN/AGENTS.md.template). Copy/adapt it as the target project's `AGENTS.md`. For other languages, translate and adapt the English template. Preserve established terminology, filenames, and quoted source titles.
- Do not translate an existing project's unrelated documents merely to change the language of its rules.

## Initialize a project

### Establish the boundary

Resolve the intended project directory from the request and current workspace. Read applicable ancestor/project `AGENTS.md` files and inspect the target's existing files, Git root, status, and ignore rules. Inspection of ancestor instructions/Git boundaries does not authorize browsing unrelated project content.

Use an existing repository without resetting it. If the target is already inside another repository, do not silently create a nested repository or change the parent repository's policy. Resolve an ambiguous repository boundary with the user before Git mutations; continue useful target-local inspection meanwhile. Preserve uncommitted user edits.

Use confirmed project goals and constraints. If the project purpose is not given, record that it has not been specified; do not invent a domain, milestone, technology stack, or acceptance criteria. Ask only when missing information prevents a safe concrete setup.

### Create a small foundation

1. Initialize local Git at the intended root if it is not already a repository and the user has not opted out. A request to initialize the project with this skill includes local Git setup. Do not set global identity, rename an existing branch, create remotes, or push.
2. Create or narrowly merge `AGENTS.md` from the selected template. Keep shared durable rules there. Adapt path conventions to the actual project; add domain rules only from the user's requirements or existing authoritative guidance. Do not inject example-specific research topics, hardware, publication workflows, or school requirements into unrelated projects.
3. Create a concise `README.md` with the confirmed purpose and entry points, plus root `STATE.md` with the present goal/stage, completed facts and evidence, unresolved items, and executable next steps. The new state may honestly say that only initialization is complete. Keep unknowns explicit.
4. Create `MEMORY.md` only when there are useful lasting decisions or lessons to preserve. Otherwise the generated rules explain its purpose without creating an empty file. Do not create `HISTORY.md`, empty phase documents, or a speculative directory tree.
5. Add project-scoped ignore rules for temporary output and known secrets as appropriate. The conventional scratch root is `/tmp/`; create its subfolders only when used. Preserve existing ignore rules and trackable examples such as `.env.example`. Do not hide source files, user input that must be preserved, or intended deliverables through broad ignore patterns.

If initialization explicitly includes multiple tracks, apply the migration guide to the confirmed starting information after establishing the shared foundation. Do not invent history for a new track.

### Verify and finish

- Check links, filenames, scope, requested language, and rule consistency. Confirm a single-track setup has no active-track mechanism. Keep checks in the conversation unless a saved check artifact is actually needed.
- Inspect the diff and Git status; stage only the relevant setup files and make a local bootstrap commit unless the user prohibited commits or a repository rule says otherwise. Never absorb unrelated changes into the commit. If identity or another Git prerequisite is missing, preserve completed files and report the concrete limitation without changing global configuration.
- Report the project path, created/merged entry points, selected language, single/multiple-track mode, and commit outcome briefly. Do not add a standalone setup report unless requested.
- Reinvocation should fill genuine gaps or apply requested changes, not rewrite unchanged files, refresh dates, duplicate sections, or create an empty commit.

## Reusable rule boundaries

The templates carry the user's reusable preferences: concise shared instructions; independent state and distilled memory; no state writes for read-only questions; reports only when requested; preservation of originals and version boundaries; project-local organization; provenance and fact/plan distinctions; relevant local commits and targeted verification.

Apply these as project agreements, not claims about past permission or completed work. In particular, do not insert “the user has already authorized” statements copied from another repository. Respect the target project's actual Git policy and any explicit exceptions. After setup, ordinary work updates the generated files directly; the skill is no longer needed.

## Invocation examples

- `Use $project-bootstrap to initialize this empty folder.` → English rules, local Git, one task track.
- `Use $project-bootstrap to initialize this project; write the project rules in Chinese.` → Chinese rules, one task track.
- `Use $project-bootstrap to separate this project into research and graduation tracks; graduation is currently active.` → evidence-based migration with one global active-track file.
- `What is the project's current progress?` → this skill must not be selected or applied.
