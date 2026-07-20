<#
.SYNOPSIS
    PKP Context Pack Generator - Repository Transport

.DESCRIPTION
    Handles creation of the Repository Transport Package.

    Repository Transport preserves the original repository
    folder hierarchy and acts as the source package for
    additional transport formats.

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : RepositoryTransport
    Version : 2.0
#>


# ============================================================
# Repository Transport Builder
# ============================================================

function Build-RepositoryTransport
{
    param
    (
        [Parameter(Mandatory)]
        [PSCustomObject]$ContextPack
    )


    Write-Host ""
    Write-Host "Building Repository Transport..."
    Write-Host ""


    if (-not $ContextPack.Success)
    {
        Write-Host "Cannot build Repository Transport."
        Write-Host "Context Pack validation failed."

        return [PSCustomObject]@{

            Success = $false

            Transport = "Repository"

            Folder = $null
        }
    }


    $RepositoryFolder = $ContextPack.RepositoryFolder


    return [PSCustomObject]@{

        Success = $true

        Transport = "Repository"

        Folder = $RepositoryFolder

        ContextPackName = $ContextPack.ContextPackName
    }
}