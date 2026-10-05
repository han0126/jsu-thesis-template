# Simulate the Typst Universe reference environment locally.
#
# Purpose: verify the @preview package can be init'd and compiled by a user,
#          without uploading anything.
# Usage:   powershell -ExecutionPolicy Bypass -File verify.ps1
#
# Note: during simulation, @preview in the entry file is rewritten to @local,
#       because @preview requires downloading from packages.typst.org.
#       The repository source keeps @preview untouched.

param(
  [string]$TypstExe = "D:\Microsoft VS Code\typst-x86_64-pc-windows-msvc\typst.exe"
)

$ErrorActionPreference = 'Continue'
$Root    = $PSScriptRoot
$Sim     = Join-Path $Root '.sim'
$PkgName = 'jsu-thesis-template'
$PkgVer  = '0.1.0'
$PkgDir  = Join-Path $Sim 'pkg'
$PkgRoot = Join-Path $PkgDir "local\$PkgName\$PkgVer"
$Proj    = Join-Path $Sim 'proj'

$script:Failed = $false

function Step($m) { Write-Host ""; Write-Host "==> $m" -ForegroundColor Cyan }
function Ok($m)   { Write-Host "    OK   $m" -ForegroundColor Green }
function Bad($m)  { Write-Host "    FAIL $m" -ForegroundColor Red; $script:Failed = $true }
function Info($m) { Write-Host "    $m" }

# --- 0. preflight -------------------------------------------------------
Step "Check typst executable"
if (-not (Test-Path $TypstExe)) {
  Bad "typst not found: $TypstExe  (pass -TypstExe)"
  exit 1
}
Ok ((& $TypstExe --version 2>&1 | Select-Object -First 1))

# --- 1. build simulated package ----------------------------------------
Step "Build simulated package (skip .git / .sim / backup / build output)"
if (Test-Path $Sim) { Remove-Item -Recurse -Force $Sim }
New-Item -ItemType Directory -Force $PkgRoot | Out-Null

# Honor the [package].exclude list from typst.toml so the simulated package
# matches what Typst Universe would actually receive.
$ExcludePatterns = @()
$TomlPath = Join-Path $Root 'typst.toml'
if (Test-Path $TomlPath) {
  $tomlText = [System.IO.File]::ReadAllText($TomlPath, [System.Text.Encoding]::UTF8)
  $m = [regex]::Match($tomlText, 'exclude\s*=\s*\[(.*?)\]', 'Singleline')
  if ($m.Success) {
    $ExcludePatterns = [regex]::Matches($m.Groups[1].Value, '"([^"]+)"') |
      ForEach-Object { $_.Groups[1].Value }
  }
}
Info ("exclude from typst.toml: " + $(if ($ExcludePatterns.Count) { $ExcludePatterns -join ', ' } else { '(none)' }))

# Always excluded: VCS metadata, our own simulation dir, editor/OS noise.
$AlwaysSkip = @('.git', '.sim', '.gitignore', '.DS_Store')

function Test-Excluded($name) {
  if ($AlwaysSkip -contains $name) { return $true }
  foreach ($pat in $ExcludePatterns) {
    # typst exclude entries are glob-ish: "*.sh", "tests", "release"
    if ($pat -eq $name) { return $true }
    if ($pat -like '*`**' -or $pat -like '*`?*' -or $pat -like '*`[*') {
      if ($name -like $pat) { return $true }
    } else {
      if ($name -like $pat) { return $true }
    }
  }
  return $false
}

Get-ChildItem -Force $Root | Where-Object { -not (Test-Excluded $_.Name) } | ForEach-Object {
  if ($_.PSIsContainer) {
    Copy-Item -Recurse $_.FullName (Join-Path $PkgRoot $_.Name)
  } else {
    Copy-Item $_.FullName $PkgRoot
  }
}
Info ("files in package: " + (Get-ChildItem -Recurse -File $PkgRoot | Measure-Object).Count)

# The dev-only self-test script must never ship with the package.
if (Test-Path (Join-Path $PkgRoot 'verify.ps1')) {
  Bad "verify.ps1 ended up inside the package - add '*.ps1' to [package].exclude"
} else {
  Ok "verify.ps1 correctly excluded from package"
}

foreach ($need in @('typst.toml', 'template.typ', 'template\main.typ', 'fonts', 'sources')) {
  if (Test-Path (Join-Path $PkgRoot $need)) { Ok "present: $need" }
  else { Bad "missing: $need" }
}

# --- 2. init ------------------------------------------------------------
Step "typst init (simulate user creating a project)"
Push-Location $Sim
& $TypstExe init "@local/${PkgName}:${PkgVer}" proj --package-path $PkgDir 2>&1 |
  Select-Object -First 3 | ForEach-Object { Info $_ }
$initCode = $LASTEXITCODE
Pop-Location
if ($initCode -eq 0) { Ok "init exit code 0" } else { Bad "init exit code $initCode" }

# init exit code alone is NOT trustworthy - always inspect the output tree
Step "Inspect user project (init success does not imply a usable project)"
if (-not (Test-Path (Join-Path $Proj 'main.typ'))) {
  Bad "user project has no main.typ - template unusable!"
} else {
  Ok "main.typ present"
}
foreach ($need in @('refs.bib', 'figures')) {
  if (Test-Path (Join-Path $Proj $need)) { Ok "present: $need" }
  else { Info "note: no $need (optional)" }
}

# --- 3. rewrite @preview -> @local (simulation only) --------------------
Step "Rewrite @preview -> @local in entry (simulation only)"
$entry = Join-Path $Proj 'main.typ'
if (Test-Path $entry) {
  $text = [System.IO.File]::ReadAllText($entry, [System.Text.Encoding]::UTF8)
  $text = $text.Replace("@preview/$PkgName", "@local/$PkgName")
  $utf8 = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($entry, $text, $utf8)
  Ok "rewritten"
} else {
  Bad "entry file missing, cannot rewrite"
}

# --- 4. compile ---------------------------------------------------------
Step "Compile user project (normal mode)"
Push-Location $Proj
$o1 = & $TypstExe compile main.typ --package-path $PkgDir 2>&1
$c1 = $LASTEXITCODE
Pop-Location
$o1 | Select-String 'error|warning' | Select-Object -First 8 | ForEach-Object { Info $_ }
if ($c1 -eq 0) { Ok "compile succeeded" } else { Bad "compile failed (exit $c1)" }
$pdf = Join-Path $Proj 'main.pdf'
if (Test-Path $pdf) { Ok ("PDF: " + (Get-Item $pdf).Length + " bytes") }
else { Bad "no PDF produced" }

# --- 5. pure environment (Linux / Web App simulation) -------------------
Step "Pure environment compile (--ignore-system-fonts)"
Push-Location $Proj
$o2 = & $TypstExe compile main.typ pure.pdf --package-path $PkgDir `
        --ignore-system-fonts --font-path (Join-Path $PkgRoot 'fonts') 2>&1
$c2 = $LASTEXITCODE
Pop-Location
$warn = $o2 | Select-String 'unknown font family'
if ($warn.Count -gt 0) {
  Bad ("$($warn.Count) font warnings:")
  $warn | Select-Object -First 5 | ForEach-Object { Info $_ }
} else {
  Ok "no font warnings"
}
if ($c2 -eq 0) { Ok "pure-mode compile succeeded" } else { Bad "pure-mode failed (exit $c2)" }

# --- result -------------------------------------------------------------
Write-Host ""
if ($script:Failed) {
  Write-Host "=== VERIFY FAILED - see FAIL lines above ===" -ForegroundColor Red
  exit 1
} else {
  Write-Host "=== ALL PASSED - template can be init'd and compiled ===" -ForegroundColor Green
  Write-Host "Artifacts: $Sim" -ForegroundColor DarkGray
  Write-Host "Cleanup  : Remove-Item -Recurse -Force '$Sim'" -ForegroundColor DarkGray
  exit 0
}
