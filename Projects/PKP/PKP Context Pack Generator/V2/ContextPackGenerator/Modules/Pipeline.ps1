<#
.SYNOPSIS
    PKP Context Pack Generator - Pipeline Functions

.DESCRIPTION
    Provides the manifest processing pipeline.

    Coordinates:
    - Manifest reading
    - Manifest entry extraction
    - Validation

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : Pipeline
    Version : 2.0
#>


# ============================================================
# Manifest Pipeline
# ============================================================

function Invoke-ManifestPipeline
{
    param
    (
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$ManifestFile,

        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    # --------------------------------------------------------
    # Read Manifest
    # --------------------------------------------------------

    $ManifestLines = Read-Manifest `
        -ManifestFile $ManifestFile



    # --------------------------------------------------------
    # Extract Manifest Entries
    # --------------------------------------------------------

    $ManifestEntries = Get-ManifestEntries `
        -ManifestLines $ManifestLines



    # --------------------------------------------------------
    # Validate Entries
    # --------------------------------------------------------

    $Validation = Validate-ManifestEntries `
        -ManifestEntries $ManifestEntries `
        -PKPRoot $PKPRoot



    # --------------------------------------------------------
    # Return Pipeline Result
    # --------------------------------------------------------

    return [PSCustomObject]@{

        ManifestFile = $ManifestFile

        ManifestEntries = $ManifestEntries

        Validation = $Validation
    }
}