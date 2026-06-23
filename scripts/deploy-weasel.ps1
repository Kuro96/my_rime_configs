param(
  [string]$TargetRimeDir = "."
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoDir = Resolve-Path (Join-Path $ScriptDir "..")
$TargetPath = New-Item -ItemType Directory -Force -Path $TargetRimeDir
$TargetDir = Resolve-Path $TargetPath.FullName

function Copy-Layer {
  param([string]$LayerPath)
  if (Test-Path $LayerPath) {
    Copy-Item -Path (Join-Path $LayerPath "*") -Destination $TargetDir.Path -Recurse -Force
  }
}

function Deploy-DefaultCustom {
  $TemplatePath = Join-Path $RepoDir.Path "templates\default.custom.yaml"
  $PatchPath = Join-Path $RepoDir.Path "platforms\weasel\default.custom.yaml.patch"
  $TargetDefault = Join-Path $TargetDir.Path "default.custom.yaml"

  if (-not (Test-Path $TemplatePath)) {
    throw "missing default template: $TemplatePath"
  }

  Copy-Item -Path $TemplatePath -Destination $TargetDefault -Force
  if (Test-Path $PatchPath) {
    git -C $TargetDir.Path apply --unsafe-paths $PatchPath
    if ($LASTEXITCODE -ne 0) {
      throw "failed to patch default.custom.yaml"
    }
  }
  Remove-Item -Path (Join-Path $TargetDir.Path "default.custom.yaml.patch") -ErrorAction SilentlyContinue
}

Copy-Layer (Join-Path $RepoDir.Path "common")
Copy-Layer (Join-Path $RepoDir.Path "private")
Copy-Layer (Join-Path $RepoDir.Path "platforms\weasel")
Deploy-DefaultCustom

Write-Output "deployed Weasel Rime config to $($TargetDir.Path)"
