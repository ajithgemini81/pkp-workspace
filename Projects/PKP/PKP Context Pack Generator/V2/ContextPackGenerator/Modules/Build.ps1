<#
.SYNOPSIS
    PKP Context Pack Generator - Build Functions

.DESCRIPTION
    Handles Context Pack build orchestration.

    Creates the Repository Package, generates metadata files,
    and returns build information for transport processing.

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : Build
    Version : 2.0
#>


# ============================================================
# Context Pack Build
# ============================================================

function Build-ContextPack
{
    param
    (
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$ManifestFile,

        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    Write-Host ""

    Write-Host "Building Context Pack:"
    Write-Host $ManifestFile.BaseName

    Write-Host ""


    # --------------------------------------------------------
    # Execute Manifest Pipeline
    # --------------------------------------------------------

    $ManifestPipeline = Invoke-ManifestPipeline `
        -ManifestFile $ManifestFile `
        -PKPRoot $PKPRoot


    if (-not $ManifestPipeline.Validation.IsValid)
    {
        Write-Host ""
        Write-Host "Validation failed."

        return [PSCustomObject]@{

            ContextPackName = $ManifestFile.BaseName

            Validation = $ManifestPipeline.Validation

            Success = $false
        }
    }


    # --------------------------------------------------------
    # Create Repository Package
    # --------------------------------------------------------

    $OutputFolder = Get-RepositoryOutputFolder `
        -PKPRoot $PKPRoot


    $BuildFolder = New-BuildFolder `
        -OutputFolder $OutputFolder `
        -ContextPackName $ManifestFile.BaseName


    # --------------------------------------------------------
    # Copy Repository Files
    # --------------------------------------------------------

    Copy-ManifestFiles `
        -ManifestEntries $ManifestPipeline.ManifestEntries `
        -PKPRoot $PKPRoot `
        -BuildFolder $BuildFolder


    # --------------------------------------------------------
    # Generate System Files
    # --------------------------------------------------------

    $StartHereFile = Write-StartHere `
        -BuildFolder $BuildFolder


    $ReportFile = Write-BuildReport `
        -BuildFolder $BuildFolder `
        -ContextPackName $ManifestFile.BaseName `
        -ManifestEntries $ManifestPipeline.ManifestEntries `
        -Validation $ManifestPipeline.Validation


    # --------------------------------------------------------
    # Return Build Object
    # --------------------------------------------------------

    return [PSCustomObject]@{

        ContextPackName = $ManifestFile.BaseName

        RepositoryFolder = $BuildFolder

        ManifestEntries = $ManifestPipeline.ManifestEntries

        Validation = $ManifestPipeline.Validation

        StartHere = $StartHereFile

        ReportFile = $ReportFile

        Success = $true
    }
}



# ============================================================
# Repository Package Folder Creation
# ============================================================

function New-BuildFolder
{
    param
    (
        [Parameter(Mandatory)]
        [string]$OutputFolder,

        [Parameter(Mandatory)]
        [string]$ContextPackName
    )


    $BuildFolder = Join-Path `
        $OutputFolder `
        $ContextPackName


    Remove-FolderIfExists `
        -Path $BuildFolder


    Ensure-Folder `
        -Path $BuildFolder


    return $BuildFolder
}



# ============================================================
# Repository File Copy
# ============================================================

function Copy-ManifestFiles
{
    param
    (
        [Parameter(Mandatory)]
        [array]$ManifestEntries,

        [Parameter(Mandatory)]
        [string]$PKPRoot,

        [Parameter(Mandatory)]
        [string]$BuildFolder
    )


    foreach ($Entry in $ManifestEntries)
    {

        $Source = Join-Path `
            $PKPRoot `
            $Entry


        $Destination = Join-Path `
            $BuildFolder `
            $Entry


        $DestinationFolder = Split-Path `
            $Destination `
            -Parent


        Ensure-Folder `
            -Path $DestinationFolder


        Copy-Item `
            -Path $Source `
            -Destination $Destination `
            -Force


        Write-Host "[COPY] $Entry"
    }
}