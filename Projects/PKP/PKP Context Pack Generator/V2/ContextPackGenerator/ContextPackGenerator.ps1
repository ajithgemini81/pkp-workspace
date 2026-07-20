<#
.SYNOPSIS
    PKP Context Pack Generator

.DESCRIPTION
    Main entry point for the PKP Context Pack Generator.

    Loads modules and starts the generation workflow.

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Version : 2.0
#>


Set-StrictMode -Version Latest

$ErrorActionPreference = "Stop"


# ============================================================
# Module Loading
# ============================================================

$ModuleFolder =
    Join-Path `
        $PSScriptRoot `
        "Modules"



$Modules = @(

    "Utilities.ps1"

    "UI.ps1"

    "Discovery.ps1"

    "Validation.ps1"

    "Pipeline.ps1"

    "Reports.ps1"

    "Build.ps1"

    "RepositoryTransport.ps1"

    "FlatTransport.ps1"

    "ZipTransport.ps1"

    "Processing.ps1"
)



foreach ($Module in $Modules)
{

    $Path =
        Join-Path `
            $ModuleFolder `
            $Module


    if (-not (Test-Path $Path))
    {
        throw "Missing module: $Path"
    }


    . $Path
}



# ============================================================
# Application Startup
# ============================================================

Clear-Host


Show-Banner



$ScriptFolder =
    Split-Path `
        -Parent `
        $MyInvocation.MyCommand.Path



$PKPRoot =
    Get-PKPRoot `
        -ScriptFolder $ScriptFolder



Write-Host "Script Folder :" $ScriptFolder

Write-Host "PKP Root      :" $PKPRoot

Write-Host ""



$DefinitionsFolder =
    Get-DefinitionsFolder `
        -PKPRoot $PKPRoot



Write-Host "Definitions   :" $DefinitionsFolder

Write-Host ""



$ContextPacks =
    Get-ContextPacks `
        -DefinitionsFolder $DefinitionsFolder



if (-not $ContextPacks)
{
    Write-Host "=========================================
				No Context Pack definitions were found.

				Expected location:

				Infrastructure\AI\ContextPacks\Definitions

				Create one or more *.txt manifest files
				and run the generator again.

				========================================="

    exit
}



Show-ContextPacks `
    -ContextPacks $ContextPacks



$Selection =
    Read-Selection



Process-Selection `
    -Selection $Selection `
    -ContextPacks $ContextPacks `
    -PKPRoot $PKPRoot