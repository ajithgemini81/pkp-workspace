# ============================================================
# User Interface Functions
# ============================================================

function Show-Banner
{
    Write-Host "========================================="
    Write-Host "      PKP Context Pack Generator"
    Write-Host "========================================="
    Write-Host ""
}

function Show-ContextPacks
{
    param
    (
        [array]$ContextPacks
    )

    Write-Host ""
    Write-Host "Available Context Packs"
    Write-Host "-----------------------"

    $Index = 1

    foreach ($Pack in $ContextPacks)
    {
        Write-Host "$Index. $($Pack.BaseName)"
        $Index++
    }

    Write-Host ""
    Write-Host "A. Generate ALL Context Packs"
    Write-Host "Q. Quit"
    Write-Host ""
}

function Read-Selection
{
    Write-Host ""

    $Selection = Read-Host "Selection"

    Write-Host ""

    return $Selection.Trim()
}

# ============================================================
# Discovery Functions
# ============================================================

function Get-PKPRoot
{
    param
    (
        [string]$ScriptFolder
    )

    $Root = Resolve-Path (
        Join-Path $ScriptFolder "..\..\.."
    )

    return $Root
}

function Get-DefinitionsFolder
{
    param
    (
        [string]$PKPRoot
    )

    $Folder = Join-Path $PKPRoot "Infrastructure\AI\ContextPacks\Definitions"

    return $Folder
}

function Get-ContextPacks
{
    param
    (
        [string]$DefinitionsFolder
    )

    $Packs = Get-ChildItem `
        -Path $DefinitionsFolder `
        -Filter "*.txt" |
        Sort-Object Name

    return $Packs
}

function Get-SelectedContextPack
{
    param
    (
        [int]$SelectedIndex,

        [array]$ContextPacks
    )

    if ($SelectedIndex -lt 1 -or $SelectedIndex -gt $ContextPacks.Count)
    {
        return $null
    }

    return $ContextPacks[$SelectedIndex - 1]
}

function Read-Manifest
{
    param
    (
        [System.IO.FileInfo]$ManifestFile
    )

    Write-Host ""
    Write-Host "Reading Manifest:"
    Write-Host $ManifestFile.FullName

    $Lines = Get-Content $ManifestFile.FullName

    return $Lines
}

function Get-ManifestEntries
{
    param
    (
        [array]$ManifestLines
    )

    $Entries = @()

    foreach ($Line in $ManifestLines)
    {
        $Line = $Line.Trim()

        if ($Line -eq "")
        {
            continue
        }

        if ($Line.StartsWith("#"))
        {
            continue
        }

        $Entries += $Line
    }

    return $Entries
}

function Get-RepositoryOutputFolder
{
    param
    (
        [string]$PKPRoot
    )

    return Join-Path `
        $PKPRoot `
        "Infrastructure\AI\ContextPacks\Output\Repository"
}


# ============================================================
# Validation Functions
# ============================================================

function Validate-ManifestEntries
{
    param
    (
        [array]$ManifestEntries,

        [string]$PKPRoot
    )

    Write-Host ""
    Write-Host "Validation"
    Write-Host "----------"
    Write-Host ""

    $ValidFiles = @()
    $MissingFiles = @()

    foreach ($Entry in $ManifestEntries)
    {
        $FullPath = Join-Path $PKPRoot $Entry

        if (Test-Path $FullPath)
        {
            Write-Host "[OK]      $Entry"
            $ValidFiles += $Entry
        }
        else
        {
            Write-Host "[MISSING] $Entry"
            $MissingFiles += $Entry
        }
    }

    $Result = [PSCustomObject]@{
        ValidFiles   = $ValidFiles
        MissingFiles = $MissingFiles
        IsValid      = ($MissingFiles.Count -eq 0)
    }

return $Result
}

# ============================================================
# Build Functions
# ============================================================

function Build-ContextPack
{
    param
    (
        [System.IO.FileInfo]$ManifestFile,

        [string]$PKPRoot
    )

    $ManifestPipeline = Invoke-ManifestPipeline `
    -ManifestFile $ManifestFile `
    -PKPRoot $PKPRoot

    $OutputFolder = Get-RepositoryOutputFolder `
    -PKPRoot $PKPRoot

    $BuildFolder = New-BuildFolder `
        -OutputFolder $OutputFolder `
        -ContextPackName $ManifestFile.BaseName

    Copy-ManifestFiles `
        -ManifestEntries $ManifestPipeline.ManifestEntries `
        -PKPRoot $PKPRoot `
        -BuildFolder $BuildFolder

    $StartHereFile = Write-StartHere `
    -BuildFolder $BuildFolder

    $ReportFile = Write-BuildReport `
    -BuildFolder $BuildFolder `
    -ContextPackName $ManifestFile.BaseName `
    -ManifestEntries $ManifestPipeline.ManifestEntries `
    -Validation $ManifestPipeline.Validation

    return [PSCustomObject]@{
        ManifestEntries = $ManifestPipeline.ManifestEntries
        Validation = $ManifestPipeline.Validation
        BuildFolder = $BuildFolder
        StartHere = $StartHereFile
        ReportFile = $ReportFile        
    }
}


# ============================================================
# Pipeline Functions
# ============================================================

function Invoke-ManifestPipeline
{
    param
    (
        [System.IO.FileInfo]$ManifestFile,

        [string]$PKPRoot
    )

    $Manifest = Read-Manifest `
        -ManifestFile $ManifestFile

    $Entries = Get-ManifestEntries `
        -ManifestLines $Manifest

    $Validation = Validate-ManifestEntries `
        -ManifestEntries $Entries `
        -PKPRoot $PKPRoot

    return [PSCustomObject]@{

        ManifestEntries = $Entries

        Validation = $Validation
    }
}


# ============================================================
# Transport Functions
# ============================================================

function Build-RepositoryTransport
{
    param
    (
        [PSCustomObject]$ContextPack
    )

    Write-Host ""
    Write-Host "Building Repository Transport..."
}

function Build-FlatTransport
{
    param
    (
        [PSCustomObject]$ContextPack
    )

    Write-Host ""
    Write-Host "Building Flat Transport..."
}

# ============================================================
# Flat Package Functions
# ============================================================

function Build-FlatPackage
{
    param
    (
        [string]$RepositoryFolder,

        [string]$FlatFolder
    )

    Write-Host ""
    Write-Host "Building Flat Package..."
}

# ============================================================
# Processing Functions
# ============================================================

function Process-Selection
{
    param
    (
        [string]$Selection,

        [array]$ContextPacks,

        [string]$PKPRoot
    )

    $Selection = $Selection.ToUpper()

    if ($Selection -eq "Q")
    {
        Write-Host "Exiting..."
        return
    }

    if ($Selection -eq "A")
    {
        Build-AllContextPacks `
            -ContextPacks $ContextPacks `
            -PKPRoot $PKPRoot

        return
    }

    [int]$SelectedIndex = 0

    if (-not [int]::TryParse($Selection, [ref]$SelectedIndex))
    {
        Write-Host ""
        Write-Host "Invalid selection."
        return
    }

    $SelectedContextPack = Get-SelectedContextPack `
        -SelectedIndex $SelectedIndex `
        -ContextPacks $ContextPacks

    if ($null -eq $SelectedContextPack)
    {
        Write-Host ""
        Write-Host "Selection out of range."
        return
    }    

    $Build = Build-ContextPack `
        -ManifestFile $SelectedContextPack `
        -PKPRoot $PKPRoot

    Write-Host ""
    Write-Host "Manifest Entries"
    Write-Host "----------------"

    foreach ($Entry in $Build.ManifestEntries)
    {
        Write-Host $Entry
    }

    Write-Host ""
    Write-Host "Validation Summary"
    Write-Host "------------------"

    Write-Host "Valid Files   :" $Build.Validation.ValidFiles.Count
    Write-Host "Missing Files :" $Build.Validation.MissingFiles.Count
    Write-Host "Overall Valid :" $Build.Validation.IsValid

    Write-Host ""
    Write-Host "Build Folder"
    Write-Host "------------"
    Write-Host $Build.BuildFolder

    Write-Host ""
    Write-Host "Build Report"
    Write-Host "------------"
    Write-Host $Build.ReportFile
}

function Build-AllContextPacks
{
    param
    (
        [array]$ContextPacks,

        [string]$PKPRoot
    )

    Write-Host ""
    Write-Host "Generating ALL Context Packs..."
    Write-Host ""

    foreach ($Pack in $ContextPacks)
    {
        Write-Host "========================================="
        Write-Host "Building: $($Pack.BaseName)"
        Write-Host "========================================="

        $Build = Build-ContextPack `
            -ManifestFile $Pack `
            -PKPRoot $PKPRoot

        Write-Host ""
        Write-Host "Result"

        if ($Build.Validation.IsValid)
        {
            Write-Host "SUCCESS"
        }
        else
        {
            Write-Host "FAILED"
        }

        Write-Host ""
    }

    Write-Host "Finished building all Context Packs."
}

# ============================================================
# Copy Functions
# ============================================================

function New-BuildFolder
{
    param
    (
        [string]$OutputFolder,

        [string]$ContextPackName
    )

    $BuildFolder = Join-Path `
        $OutputFolder `
        $ContextPackName

    if (Test-Path $BuildFolder)
    {
        Remove-Item `
            -Path $BuildFolder `
            -Recurse `
            -Force
    }

    New-Item `
        -ItemType Directory `
        -Path $BuildFolder | Out-Null

    return $BuildFolder
}

function Copy-ManifestFiles
{
    param
    (
        [array]$ManifestEntries,

        [string]$PKPRoot,

        [string]$BuildFolder
    )

    foreach ($Entry in $ManifestEntries)
    {
        $Source = Join-Path $PKPRoot $Entry
        $Destination = Join-Path $BuildFolder $Entry

        $DestinationFolder = Split-Path `
            $Destination `
            -Parent

        if (-not (Test-Path $DestinationFolder))
        {
            New-Item `
                -ItemType Directory `
                -Path $DestinationFolder `
                -Force | Out-Null
        }

        Copy-Item `
            -Path $Source `
            -Destination $Destination `
            -Force

        Write-Host "[COPY] $Entry"
    }
}

# ============================================================
# Generated File Functions
# ============================================================

function Write-StartHere
{
    param
    (
        [string]$BuildFolder
    )

    $File = Join-Path $BuildFolder "START-HERE.md"

    $Lines = @()

    $Lines += "# START HERE"
    $Lines += ""
    $Lines += "## Purpose"
    $Lines += ""
    $Lines += "This Context Pack initializes an AI assistant with the minimum knowledge required to continue development of the Personal Knowledge Platform (PKP)."
    $Lines += ""
    $Lines += "---"
    $Lines += ""
    $Lines += "## Reading Order"
    $Lines += ""
    $Lines += "1. README.md"
    $Lines += "2. Projects/PKP/PKP-001 - AI Collaboration Guide.md"
    $Lines += "3. Projects/PKP/PKP-999 - Current Project Status.md"
    $Lines += "4. Architecture documents"
    $Lines += "5. Standards"
    $Lines += ""
    $Lines += "---"
    $Lines += ""
    $Lines += "If additional context is required, request the appropriate Context Pack."

    Set-Content `
        -Path $File `
        -Value $Lines

    return $File
}

# ============================================================
# Report Functions
# ============================================================

function Write-BuildReport
{
    param
    (
        [string]$BuildFolder,

        [string]$ContextPackName,

        [array]$ManifestEntries,

        [PSCustomObject]$Validation
    )

    $ReportFile = Join-Path $BuildFolder "BuildReport.md"

    $Lines = @()

    $Lines += "# Build Report"
    $Lines += ""
    $Lines += "## Context Pack"
    $Lines += ""
    $Lines += $ContextPackName
    $Lines += ""
    $Lines += "## Generated"
    $Lines += ""
    $Lines += (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    $Lines += ""
    $Lines += "## Files"
    $Lines += ""

    foreach ($Entry in $ManifestEntries)
    {
        $Lines += "- $Entry"
    }

    $Lines += ""
    $Lines += "## Validation"
    $Lines += ""
    $Lines += "- Valid Files: $($Validation.ValidFiles.Count)"
    $Lines += "- Missing Files: $($Validation.MissingFiles.Count)"
    $Lines += "- Success: $($Validation.IsValid)"

    Set-Content `
        -Path $ReportFile `
        -Value $Lines

    return $ReportFile
}


# ============================================================
# Utility Functions
# ============================================================

# (Reusable helper functions will be added here)


# ============================================================
# Main Program
# ============================================================

Clear-Host
Show-Banner

$ScriptFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
$PKPRoot = Get-PKPRoot -ScriptFolder $ScriptFolder

Write-Host "Script Folder :" $ScriptFolder
Write-Host "PKP Root      :" $PKPRoot
Write-Host ""

$DefinitionsFolder = Get-DefinitionsFolder -PKPRoot $PKPRoot

Write-Host "Definitions   :" $DefinitionsFolder

$ContextPacks = Get-ContextPacks -DefinitionsFolder $DefinitionsFolder

Show-ContextPacks -ContextPacks $ContextPacks

$Selection = Read-Selection

Process-Selection `
    -Selection $Selection `
    -ContextPacks $ContextPacks `
    -PKPRoot $PKPRoot

# ============================================================