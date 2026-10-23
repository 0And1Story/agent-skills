# Compatible with Windows PowerShell 5.1 and PowerShell 7+.
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [ValidateSet('codex', 'claude')]
    [string]$Agent = 'codex',

    [Alias('p', '-path')]
    [ValidateNotNullOrEmpty()]
    [string]$Path,

    [Alias('h')]
    [switch]$Help
)

$ErrorActionPreference = 'Stop'

if ($Help) {
    Write-Output @'
Usage: ./install.ps1 [codex|claude] [-Path DIRECTORY]

  codex              Install to ~/.codex/skills (default)
  claude             Install to ~/.claude/skills
  -Path, --path, -p  Override the destination skills folder
  -Help, -h          Show this help

Windows uses directory junctions; other platforms use symbolic links.
Existing entries are never overwritten. Conflicts cause exit status 1.
'@
    exit 0
}

function Test-IsWithin {
    param([string]$Child, [string]$Parent)
    $comparison = [System.StringComparison]::Ordinal
    if ($env:OS -eq 'Windows_NT') {
        $comparison = [System.StringComparison]::OrdinalIgnoreCase
    }
    $prefix = $Parent.TrimEnd([char[]]@('\', '/')) + [System.IO.Path]::DirectorySeparatorChar
    return $Child.Equals($Parent, $comparison) -or $Child.StartsWith($prefix, $comparison)
}

function Get-PhysicalPath {
    param([string]$InputPath, [int]$LinksFollowed = 0)
    if ($LinksFollowed -gt 40) { throw "Too many links in path: $InputPath" }
    $fullPath = [System.IO.Path]::GetFullPath($InputPath)
    $root = [System.IO.Path]::GetPathRoot($fullPath)
    if ($fullPath -eq $root) { return $root }
    $fullPath = $fullPath.TrimEnd([char[]]@('\', '/'))
    $parent = Get-PhysicalPath ([System.IO.Path]::GetDirectoryName($fullPath)) $LinksFollowed
    $candidate = Join-Path $parent ([System.IO.Path]::GetFileName($fullPath))
    $item = Get-Item -LiteralPath $candidate -Force -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType -in @('SymbolicLink', 'Junction')) {
        $target = @($item.Target)[0]
        if ($target) {
            if (-not [System.IO.Path]::IsPathRooted($target)) {
                $target = Join-Path $parent $target
            }
            return Get-PhysicalPath $target ($LinksFollowed + 1)
        }
    }
    return $candidate
}

try {
    $repoDir = Get-PhysicalPath $PSScriptRoot
    if (-not $Path) {
        $agentFolder = '.codex'
        if ($Agent -eq 'claude') { $agentFolder = '.claude' }
        $Path = Join-Path (Join-Path $HOME $agentFolder) 'skills'
    }
    if ($Path -eq '~') {
        $Path = $HOME
    } elseif ($Path.StartsWith('~/') -or $Path.StartsWith('~\')) {
        $Path = Join-Path $HOME $Path.Substring(2)
    }
    # Resolve relative paths against the caller's PowerShell location.
    $destination = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Path)
    $destination = Get-PhysicalPath $destination
    if (Test-IsWithin $destination $repoDir) {
        throw "Destination must be outside the repository: $destination"
    }

    $skills = @(Get-ChildItem -LiteralPath $repoDir -Directory | Where-Object {
        -not $_.Name.StartsWith('.') -and $_.Name -ne '__pycache__'
    } | Sort-Object Name)
    foreach ($skill in $skills) {
        if (Test-IsWithin $destination (Get-PhysicalPath $skill.FullName)) {
            throw "Destination is inside a source skill: $($skill.FullName)"
        }
    }

    Write-Output "Agent: $Agent"
    Write-Output "Destination: $destination"
    if ($skills.Count -eq 0) {
        Write-Output 'No skill directories found. Nothing to install.'
        exit 0
    }
    # Creating paths via .NET treats wildcard characters literally.
    $null = [System.IO.Directory]::CreateDirectory($destination)
    $entries = @{}
    if ($env:OS -ne 'Windows_NT') {
        $entries = [System.Collections.Hashtable]::new([System.StringComparer]::Ordinal)
    }
    foreach ($entry in Get-ChildItem -LiteralPath $destination -Force) {
        $entries[$entry.Name] = $entry
    }

    $installed = 0
    $unchanged = 0
    $failed = 0
    $linkType = 'SymbolicLink'
    if ($env:OS -eq 'Windows_NT') { $linkType = 'Junction' }

    foreach ($skill in $skills) {
        $link = Join-Path $destination $skill.Name
        try {
            if ($entries.ContainsKey($skill.Name)) {
                $entry = $entries[$skill.Name]
                $matches = $false
                if ($entry.LinkType -in @('SymbolicLink', 'Junction')) {
                    $target = @($entry.Target)[0]
                    if ($target) {
                        if (-not [System.IO.Path]::IsPathRooted($target)) {
                            $target = Join-Path $destination $target
                        }
                        $target = Get-PhysicalPath $target
                        $sourcePath = Get-PhysicalPath $skill.FullName
                        $matches = (Test-IsWithin $target $sourcePath) -and (Test-IsWithin $sourcePath $target)
                    }
                }
                if ($matches) {
                    Write-Output "[OK] $($skill.Name) is already linked."
                    $unchanged++
                } else {
                    Write-Warning "[CONFLICT] $link already exists; left untouched."
                    $failed++
                }
                continue
            }

            $literalTarget = $skill.FullName
            if ($PSVersionTable.PSVersion.Major -le 5) {
                # Windows PowerShell interprets junction targets as wildcard paths.
                $literalTarget = [System.Management.Automation.WildcardPattern]::Escape($literalTarget)
            }
            $null = New-Item -ItemType $linkType -Path $link -Target $literalTarget
            Write-Output "[LINK] $link -> $($skill.FullName)"
            $installed++
        } catch {
            Write-Warning "[ERROR] $($skill.Name): $($_.Exception.Message)"
            $failed++
        }
    }
    Write-Output "Installed: $installed; already linked: $unchanged; conflicts/errors: $failed"
    if ($failed -gt 0) { exit 1 }
} catch {
    Write-Warning $_.Exception.Message
    exit 1
}
