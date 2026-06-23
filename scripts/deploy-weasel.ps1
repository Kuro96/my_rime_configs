param(
  [Parameter(Mandatory = $true)]
  [string]$TargetRimeDir
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Resolve-Path (Join-Path $ScriptDir "..")
$TargetPath = New-Item -ItemType Directory -Force -Path $TargetRimeDir
$TargetDir = Resolve-Path $TargetPath.FullName

if ($TargetDir.Path -eq $RepoDir.Path) {
  throw "refusing to deploy into source repo: $($RepoDir.Path)"
}

function Copy-Layer {
  param([string]$LayerPath)
  if (Test-Path $LayerPath) {
    Copy-Item -Path (Join-Path $LayerPath "*") -Destination $TargetDir.Path -Recurse -Force
  }
}

Copy-Layer (Join-Path $RepoDir.Path "common")
Copy-Layer (Join-Path $RepoDir.Path "private")
Copy-Layer (Join-Path $RepoDir.Path "platforms\weasel")

Write-Output "deployed Weasel Rime config to $($TargetDir.Path)"
