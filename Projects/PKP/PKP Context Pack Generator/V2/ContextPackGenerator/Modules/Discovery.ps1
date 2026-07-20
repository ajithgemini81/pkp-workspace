<#
.SYNOPSIS
    PKP Context Pack Generator - Discovery Functions

.DESCRIPTION
    Provides functions responsible for locating PKP resources,
    discovering Context Pack definitions, and reading manifests.

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : Discovery
    Version : 2.0
#>


# ============================================================
# PKP Repository Discovery
# ============================================================

function Get-PKPRoot
{
    param
    (
        [Parameter(Mandatory)]
        [string]$ScriptFolder
    )

    $CurrentFolder = Resolve-Path $ScriptFolder

    while ($true)
    {
        $MarkerFile = Join-Path `
            $CurrentFolder `
            ".pkp-root"

        if (Test-Path $MarkerFile)
        {
            return $CurrentFolder
        }

        $ParentFolder = Split-Path `
            $CurrentFolder `
            -Parent

        if (
            [string]::IsNullOrWhiteSpace($ParentFolder) -or
            $ParentFolder -eq $CurrentFolder
        )
        {
            break
        }

        $CurrentFolder = $ParentFolder
    }

    throw @"

Unable to locate the PKP repository.

Expected to find:

    .pkp-root

Starting search from:

    $ScriptFolder

"@
}


# ============================================================
# Context Pack Definition Discovery
# ============================================================

function Get-DefinitionsFolder
{
    param
    (
        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    return Join-Path `
        $PKPRoot `
        "Infrastructure\AI\ContextPacks\Definitions"
}


function Get-ContextPacks
{
    param
    (
        [Parameter(Mandatory)]
        [string]$DefinitionsFolder
    )

	if (-not (Test-Path $DefinitionsFolder))
	{
		throw "Definitions folder not found: $DefinitionsFolder"
	}

    $Packs = @(
        Get-ChildItem `
            -Path $DefinitionsFolder `
            -Filter "*.txt" `
            -File |
        Sort-Object Name
    )

    return $Packs
}


# ============================================================
# Manifest Reading
# ============================================================

function Read-Manifest
{
    param
    (
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$ManifestFile
    )


    Write-Host ""
    Write-Host "Reading Manifest:"
    Write-Host $ManifestFile.FullName
    Write-Host ""


    $Lines = Get-Content `
        -Path $ManifestFile.FullName `
        -Encoding UTF8


    return $Lines
}


# ============================================================
# Manifest Processing
# ============================================================

function Get-ManifestEntries
{
    param
    (
        [Parameter(Mandatory)]
        [array]$ManifestLines
    )


    $Entries = @()


    foreach ($Line in $ManifestLines)
    {
        $CleanLine = $Line.Trim()


        # Ignore blank lines

        if ($CleanLine -eq "")
        {
            continue
        }


        # Ignore comments

        if ($CleanLine.StartsWith("#"))
        {
            continue
        }


        $Entries += $CleanLine
    }


    return $Entries
}


# ============================================================
# Output Locations
# ============================================================

function Get-OutputFolder
{
    param
    (
        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    return Join-Path `
        $PKPRoot `
        "Infrastructure\AI\ContextPacks\Output"
}


function Get-RepositoryOutputFolder
{
    param
    (
        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    return Join-Path `
        $PKPRoot `
        "Infrastructure\AI\ContextPacks\Output\Repository"
}


function Get-FlatOutputFolder
{
    param
    (
        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    return Join-Path `
        $PKPRoot `
        "Infrastructure\AI\ContextPacks\Output\Flat"
}


function Get-ZipOutputFolder
{
    param
    (
        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    return Join-Path `
        $PKPRoot `
        "Infrastructure\AI\ContextPacks\Output\Zip"
}


function Get-SelectedContextPack
{
    param
    (
        [int]$SelectedIndex,

        [array]$ContextPacks
    )


    if (
        $SelectedIndex -lt 1 -or
        $SelectedIndex -gt $ContextPacks.Count
    )
    {
        return $null
    }


    return $ContextPacks[$SelectedIndex - 1]
}