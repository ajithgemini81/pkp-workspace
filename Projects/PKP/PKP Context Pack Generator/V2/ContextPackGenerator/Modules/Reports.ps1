<#
.SYNOPSIS
    PKP Context Pack Generator - Report Functions

.DESCRIPTION
    Generates documentation files inside Context Packages.

    Generated files:
    - START-HERE.md
    - BuildReport.md

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : Reports
    Version : 2.0
#>


# ============================================================
# START-HERE Generator
# ============================================================

function Write-StartHere
{
    param
    (
        [Parameter(Mandatory)]
        [string]$BuildFolder
    )


    $File = Join-Path `
        $BuildFolder `
        "START-HERE.md"



    $Lines = @()


    $Lines += "# START HERE"

    $Lines += ""

    $Lines += "## Purpose"

    $Lines += ""

    $Lines += "This Context Pack initializes an AI assistant with the minimum knowledge required to continue work on the Personal Knowledge Platform (PKP)."

    $Lines += ""

    $Lines += "---"

    $Lines += ""

    $Lines += "## Reading Order"

    $Lines += ""

    $Lines += "1. README.md"

    $Lines += "2. PKP Collaboration Guide"

    $Lines += "3. PKP Current Project Status"

    $Lines += "4. Architecture Documents"

    $Lines += "5. Standards"

    $Lines += ""

    $Lines += "---"

    $Lines += ""

    $Lines += "## AI Continuity"

    $Lines += ""

    $Lines += "This Context Pack is a transport representation of the PKP repository."

    $Lines += ""

    $Lines += "The repository remains the single source of truth."

    $Lines += ""

    $Lines += "If additional context is required, request the appropriate Context Pack."



    Set-Content `
        -Path $File `
        -Value $Lines `
        -Encoding UTF8



    return $File
}



# ============================================================
# Build Report Generator
# ============================================================

function Write-BuildReport
{
    param
    (
        [Parameter(Mandatory)]
        [string]$BuildFolder,

        [Parameter(Mandatory)]
        [string]$ContextPackName,

        [Parameter(Mandatory)]
        [array]$ManifestEntries,

        [Parameter(Mandatory)]
        [PSCustomObject]$Validation
    )


    $ReportFile = Join-Path `
        $BuildFolder `
        "BuildReport.md"



    $Lines = @()


    $Lines += "# Build Report"

    $Lines += ""

    $Lines += "## Context Pack"

    $Lines += ""

    $Lines += $ContextPackName

    $Lines += ""

    $Lines += "## Generated"

    $Lines += ""

    $Lines += (
        Get-Date `
            -Format "yyyy-MM-dd HH:mm:ss"
    )


    $Lines += ""

    $Lines += "---"

    $Lines += ""

    $Lines += "## Files"

    $Lines += ""



    foreach ($Entry in $ManifestEntries)
    {
        $Lines += "- $Entry"
    }



    $Lines += ""

    $Lines += "---"

    $Lines += ""

    $Lines += "## Validation"

    $Lines += ""

    $Lines += "- Total Files: $($Validation.TotalFiles)"

    $Lines += "- Valid Files: $($Validation.ValidCount)"

    $Lines += "- Missing Files: $($Validation.MissingCount)"

    $Lines += "- Success: $($Validation.IsValid)"



    Set-Content `
        -Path $ReportFile `
        -Value $Lines `
        -Encoding UTF8



    return $ReportFile
}