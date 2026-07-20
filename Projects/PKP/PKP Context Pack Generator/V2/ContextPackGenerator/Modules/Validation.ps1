<#
.SYNOPSIS
    PKP Context Pack Generator - Validation Functions

.DESCRIPTION
    Provides validation functions used to verify that
    Context Pack manifest entries are valid before build.

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : Validation
    Version : 2.0
#>


# ============================================================
# Manifest Validation
# ============================================================

function Validate-ManifestEntries
{
    param
    (
        [Parameter(Mandatory)]
        [array]$ManifestEntries,

        [Parameter(Mandatory)]
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
        $FullPath = Join-Path `
            $PKPRoot `
            $Entry


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

        ValidFiles = $ValidFiles

        MissingFiles = $MissingFiles

        TotalFiles = $ManifestEntries.Count

        ValidCount = $ValidFiles.Count

        MissingCount = $MissingFiles.Count

        IsValid = (
            $MissingFiles.Count -eq 0
        )
    }


    Write-Host ""

    return $Result
}


# ============================================================
# Validation Helpers
# ============================================================

function Test-ManifestValid
{
    param
    (
        [Parameter(Mandatory)]
        [PSCustomObject]$Validation
    )


    return $Validation.IsValid
}


function Get-ValidationSummary
{
    param
    (
        [Parameter(Mandatory)]
        [PSCustomObject]$Validation
    )


    return [PSCustomObject]@{

        Total = $Validation.TotalFiles

        Valid = $Validation.ValidCount

        Missing = $Validation.MissingCount

        Success = $Validation.IsValid
    }
}


# ============================================================
# Display Helpers
# ============================================================

function Show-MissingFiles
{
    param
    (
        [Parameter(Mandatory)]
        [PSCustomObject]$Validation
    )


    if ($Validation.MissingFiles.Count -eq 0)
    {
        return
    }


    Write-Host ""

    Write-Host "Missing Files"
    Write-Host "-------------"


    foreach ($File in $Validation.MissingFiles)
    {
        Write-Host $File
    }


    Write-Host ""
}