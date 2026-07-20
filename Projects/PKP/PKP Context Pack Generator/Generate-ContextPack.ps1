# ============================================================
# PKP Context Pack Generator
#
# Version : 0.1.0
# Status  : In Development
#
# ============================================================

Clear-Host

Write-Host ""
Write-Host "========================================="
Write-Host "      PKP Context Pack Generator"
Write-Host "========================================="
Write-Host ""

# Location of this script
$ScriptFolder = $PSScriptRoot

# PKP repository root (three levels up)
$PKPRoot = Resolve-Path (Join-Path $ScriptFolder "..\..\..")

Write-Host "Script Folder :" $ScriptFolder
Write-Host "PKP Root      :" $PKPRoot
Write-Host ""

# ------------------------------------------------------------
# Locate Context Pack Definitions
# ------------------------------------------------------------

$DefinitionsFolder = Join-Path $PKPRoot "Infrastructure\AI\ContextPacks\Definitions"

Write-Host "Definitions   :" $DefinitionsFolder
Write-Host ""

# Find all definition files
$ContextPacks = Get-ChildItem `
    -Path $DefinitionsFolder `
    -Filter "*.txt" `
    | Sort-Object Name

Write-Host "Available Context Packs"
Write-Host "-----------------------"

$index = 1

foreach ($Pack in $ContextPacks)
{
    Write-Host "$index. $($Pack.BaseName)"
    $index++
}

Write-Host ""

Write-Host "A. Generate ALL Context Packs"
Write-Host "Q. Quit"
Write-Host ""

$Selection = Read-Host "Selection"

Write-Host ""

Write-Host "You selected: $Selection"
Write-Host ""

# ------------------------------------------------------------
# Quit
# ------------------------------------------------------------

if ($Selection -eq "Q")
{
    Write-Host "Exiting..."
    return
}

# ------------------------------------------------------------
# Generate ALL
# ------------------------------------------------------------

if ($Selection.ToUpper() -eq "A")
{
    Write-Host "Generating ALL Context Packs..."
    return
}

# ------------------------------------------------------------
# Single Context Pack
# ------------------------------------------------------------

[int]$PackIndex = $Selection - 1

if ($PackIndex -ge 0 -and $PackIndex -lt $ContextPacks.Count)
{
    $SelectedPack = $ContextPacks[$PackIndex]

    Write-Host ""
    Write-Host "Selected Context Pack:"
    Write-Host $SelectedPack.BaseName

# ------------------------------------------------------------
# Read Context Pack Manifest
# ------------------------------------------------------------

$ManifestEntries = Get-Content $SelectedPack.FullName -Encoding UTF8 |
    Where-Object {
        $_.Trim() -ne "" -and
        -not $_.Trim().StartsWith("#")
    }

Write-Host ""
Write-Host "Manifest Entries"
Write-Host "----------------"

$ValidFiles = @()
$MissingFiles = @()

foreach ($RelativePath in $ManifestEntries)
{
    $SourceFile = Join-Path $PKPRoot $RelativePath

    if (Test-Path $SourceFile)
    {
        Write-Host "[OK] $RelativePath"
        $ValidFiles += $RelativePath
    }
    else
    {
        Write-Host "[MISSING] $RelativePath"
        $MissingFiles += $RelativePath
    }
}

Write-Host ""
Write-Host "Validation"
Write-Host "----------"

Write-Host ""
Write-Host "Validation Summary"
Write-Host "------------------"
Write-Host "Valid Files   : $($ValidFiles.Count)"
Write-Host "Missing Files : $($MissingFiles.Count)"

}
else
{
    Write-Host ""
    Write-Host "Invalid selection."
}