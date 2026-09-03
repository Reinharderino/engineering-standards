#Requires -Version 5.1
<#
.SYNOPSIS
    Installs the engineering-standards baseline.
.DESCRIPTION
    No argument : installs the Claude Code skill user-wide (%USERPROFILE%\.claude\skills).
    With a path : copies every target into that repository — .cursor\rules\, .github\,
                  .claude\skills\ and AGENTS.md.

    The generated files (.cursor, .github, AGENTS.md) are committed to this repo, so
    installing needs no build step. Regenerating them after editing
    skills\engineering-standards\ requires bash — Git Bash or WSL — and scripts\build.sh.
.EXAMPLE
    .\scripts\install.ps1
.EXAMPLE
    .\scripts\install.ps1 C:\src\my-project
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string] $TargetRepo
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
$skill = Join-Path $root 'skills\engineering-standards'

if (-not (Test-Path (Join-Path $skill 'SKILL.md'))) {
    throw "source not found: $skill\SKILL.md"
}

function Copy-Skill {
    param([string] $DestinationParent)
    $dest = Join-Path $DestinationParent 'engineering-standards'
    if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
    New-Item -ItemType Directory -Path $DestinationParent -Force | Out-Null
    Copy-Item $skill $dest -Recurse -Force
    return $dest
}

if (-not $TargetRepo) {
    $claudeHome = $env:CLAUDE_HOME
    if (-not $claudeHome) { $claudeHome = Join-Path $env:USERPROFILE '.claude' }
    $dest = Copy-Skill (Join-Path $claudeHome 'skills')
    Write-Host "installed skill -> $dest"
    exit 0
}

if (-not (Test-Path $TargetRepo -PathType Container)) {
    throw "no such directory: $TargetRepo"
}
$target = (Resolve-Path $TargetRepo).Path

foreach ($d in '.cursor\rules', '.github\instructions', '.claude\skills') {
    New-Item -ItemType Directory -Path (Join-Path $target $d) -Force | Out-Null
}

Copy-Item (Join-Path $root '.cursor\rules\*.mdc') (Join-Path $target '.cursor\rules') -Force
Copy-Item (Join-Path $root '.github\copilot-instructions.md') (Join-Path $target '.github') -Force
Copy-Item (Join-Path $root '.github\instructions\*.instructions.md') (Join-Path $target '.github\instructions') -Force

$agents = Join-Path $target 'AGENTS.md'
$hadAgents = Test-Path $agents
if (-not $hadAgents) { Copy-Item (Join-Path $root 'AGENTS.md') $agents -Force }

Copy-Skill (Join-Path $target '.claude\skills') | Out-Null

Write-Host "installed -> ${target}: .cursor\rules\, .github\, .claude\skills\"
if ($hadAgents) { Write-Host 'note: AGENTS.md already existed, left untouched - merge by hand' }
