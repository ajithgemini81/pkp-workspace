<#
.SYNOPSIS
    PKP Context Pack Generator - ZIP Transport

.DESCRIPTION
    Creates ZIP archives from generated transport packages.

    Supports:
    - Repository Package ZIP
    - Flat Package ZIP

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : ZipTransport
    Version : 2.0
#>


# ============================================================
# ZIP Transport Builder
# ============================================================

function Build-ZipTransport
{
    param
    (
        [Parameter(Mandatory)]
        [PSCustomObject]$TransportPackage,

        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    Write-Host ""
    Write-Host "Building ZIP Transport..."
    Write-Host ""


    if (-not $TransportPackage.Success)
    {
        return [PSCustomObject]@{

            Success = $false

            Transport = "ZIP"

            Archive = $null
        }
    }


    $ZipFolder = Get-ZipOutputFolder `
        -PKPRoot $PKPRoot


    Ensure-Folder `
        -Path $ZipFolder



    $Archive = New-ZipArchive `
        -SourceFolder $TransportPackage.Folder `
        -OutputFolder $ZipFolder `
        -ContextPackName $TransportPackage.ContextPackName `
        -TransportName $TransportPackage.Transport



    return [PSCustomObject]@{

        Success = $true

        Transport = "ZIP"

        Archive = $Archive

        Source = $TransportPackage.Folder
    }
}



# ============================================================
# ZIP Creation
# ============================================================

function New-ZipArchive
{
    param
    (
        [Parameter(Mandatory)]
        [string]$SourceFolder,

        [Parameter(Mandatory)]
        [string]$OutputFolder,

        [Parameter(Mandatory)]
        [string]$ContextPackName,

        [Parameter(Mandatory)]
        [string]$TransportName
    )


    $ArchiveName =
        "$ContextPackName-$TransportName.zip"



    $ArchivePath =
        Join-Path `
            $OutputFolder `
            $ArchiveName



    if (Test-Path $ArchivePath)
    {
        Remove-Item `
            -Path $ArchivePath `
            -Force
    }



    Compress-Archive `
        -Path "$SourceFolder\*" `
        -DestinationPath $ArchivePath `
        -CompressionLevel Optimal



    Write-Host "[ZIP] $ArchivePath"



    return $ArchivePath
}