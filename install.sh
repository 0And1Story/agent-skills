#!/usr/bin/env bash
# Linux installer. Requires Bash and GNU coreutils (realpath, mkdir, ln).
set -euo pipefail

usage() {
    cat <<'EOF'
Usage: bash install.sh [codex|claude] [-p|--path DIRECTORY]

Link each non-hidden directory beside this script into an agent's skills folder.

  codex                  Install to ~/.codex/skills (default)
  claude                 Install to ~/.claude/skills
  -p, --path DIRECTORY    Override the destination skills folder
  -h, --help              Show this help

Existing entries are never overwritten. Conflicts cause exit status 1.
EOF
}

argument_error() {
    printf 'Error: %s\n' "$1" >&2
    usage >&2
    exit 2
}

agent=codex
agent_seen=false
destination=
while (( $# > 0 )); do
    case "$1" in
        codex|claude)
            if [[ $agent_seen == true ]]; then
                argument_error 'Specify only one agent.'
            fi
            agent=$1
            agent_seen=true
            shift
            ;;
        -p|--path)
            if (( $# < 2 )) || [[ -z $2 || $2 == -* ]]; then
                argument_error "$1 requires a directory."
            fi
            destination=$2
            shift 2
            ;;
        --path=*)
            destination=${1#*=}
            [[ -n $destination ]] || argument_error '--path requires a directory.'
            shift
            ;;
        -h|--help) usage; exit 0 ;;
        *) argument_error "Unknown argument: $1" ;;
    esac
done

if [[ -z $destination ]]; then
    case "$agent" in
        codex) destination=$HOME/.codex/skills ;;
        claude) destination=$HOME/.claude/skills ;;
    esac
fi
case "$destination" in
    '~') destination=$HOME ;;
    '~/'*) destination=$HOME/${destination:2} ;;
esac

script_path=$(realpath -- "${BASH_SOURCE[0]}")
repo_dir=$(dirname -- "$script_path")
destination=$(realpath -m -- "$destination")
case "$destination/" in
    "$repo_dir/"*)
        printf 'Error: destination must be outside the repository: %s\n' "$destination" >&2
        exit 1
        ;;
esac

shopt -s nullglob
skills=()
for source in "$repo_dir"/*; do
    [[ -d $source ]] || continue
    [[ ${source##*/} != __pycache__ ]] || continue
    resolved_source=$(realpath -- "$source")
    case "$destination/" in
        "$resolved_source/"*)
            printf 'Error: destination is inside a source skill: %s\n' "$source" >&2
            exit 1
            ;;
    esac
    skills+=("$source")
done

printf 'Agent: %s\nDestination: %s\n' "$agent" "$destination"
if (( ${#skills[@]} == 0 )); then
    printf 'No skill directories found. Nothing to install.\n'
    exit 0
fi
mkdir -p -- "$destination"

installed=0
unchanged=0
failed=0
for source in "${skills[@]}"; do
    name=${source##*/}
    link=$destination/$name
    if [[ -e $link || -L $link ]]; then
        if [[ -L $link && $link -ef $source ]]; then
            printf '[OK] %s is already linked.\n' "$name"
            unchanged=$((unchanged + 1))
        else
            printf '[CONFLICT] %s already exists; left untouched.\n' "$link" >&2
            failed=$((failed + 1))
        fi
    elif ln -sT -- "$source" "$link"; then
        printf '[LINK] %s -> %s\n' "$link" "$source"
        installed=$((installed + 1))
    else
        printf '[ERROR] Could not link %s.\n' "$name" >&2
        failed=$((failed + 1))
    fi
done

printf 'Installed: %d; already linked: %d; conflicts/errors: %d\n' "$installed" "$unchanged" "$failed"
(( failed == 0 ))
