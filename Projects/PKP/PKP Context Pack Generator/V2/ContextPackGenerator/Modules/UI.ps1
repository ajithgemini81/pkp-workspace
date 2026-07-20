<#
.SYNOPSIS
    PKP Context Pack Generator - User Interface Functions

.DESCRIPTION
    Provides console-based user interaction functions.

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : UI
    Version : 2.0
#>


# ============================================================
# Banner
# ============================================================

function Show-Banner
{
    Write-Host "========================================="
    Write-Host "      PKP Context Pack Generator"
    Write-Host "              Version 2.0"
    Write-Host "========================================="
    Write-Host ""
}


# ============================================================
# Context Pack Selection
# ============================================================

function Show-ContextPacks
{
    param
    (
        [Parameter(Mandatory)]
        [array]$ContextPacks
    )


    Write-Host ""
    Write-Host "Available Context Packs"
    Write-Host "-----------------------"
    Write-Host ""


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
# Build Options
# ============================================================

function Show-TransportOptions
{
    Write-Host ""
    Write-Host "Available Transport Options"
    Write-Host "---------------------------"
    Write-Host ""

    Write-Host "1. Repository Package"
    Write-Host "2. Flat Package"
    Write-Host "3. Repository + Flat Package"
    Write-Host "4. Repository + Flat + ZIP"
    Write-Host ""

}


function Read-TransportSelection
{
    Write-Host ""

    $Selection = Read-Host "Transport Selection"

    Write-Host ""

    return $Selection.Trim()
}


# ============================================================
# Progress Display
# ============================================================

function Show-BuildStarted
{
    param
    (
        [string]$ContextPackName
    )


    Write-Host ""
    Write-Host "========================================="
    Write-Host "Building: $ContextPackName"
    Write-Host "========================================="
    Write-Host ""
}


function Show-BuildCompleted
{
    param
    (
        [string]$ContextPackName
    )


    Write-Host ""
    Write-Host "Completed:"
    Write-Host $ContextPackName
    Write-Host ""
}


# ============================================================
# Validation Display
# ============================================================

function Show-ValidationSummary
{
    param
    (
        [Parameter(Mandatory)]
        [PSCustomObject]$Validation
    )


    Write-Host ""
    Write-Host "Validation Summary"
    Write-Host "------------------"

    Write-Host "Valid Files   :" `
        $Validation.ValidFiles.Count

    Write-Host "Missing Files :" `
        $Validation.MissingFiles.Count

    Write-Host "Overall Valid :" `
        $Validation.IsValid

    Write-Host ""
}


# ============================================================
# Output Display
# ============================================================

function Show-BuildLocation
{
    param
    (
        [string]$Path
    )


    Write-Host ""
    Write-Host "Output Location"
    Write-Host "---------------"

    Write-Host $Path

    Write-Host ""
}


function Show-GeneratedFile
{
    param
    (
        [string]$File
    )


    Write-Host ""
    Write-Host "Generated File"
    Write-Host "--------------"

    Write-Host $File

    Write-Host ""
}


# ============================================================
# Error Display
# ============================================================

function Show-ApplicationError
{
    param
    (
        [string]$Message
    )


    Write-Host ""
    Write-Host "========================================="
    Write-Host "ERROR"
    Write-Host "========================================="
    Write-Host ""

    Write-Host $Message

    Write-Host ""
}