<#
.SYNOPSIS
    PKP Context Pack Generator
.DESCRIPTION
    Main entry point for the PKP Context Pack Generator with Error Logging & Pause.
.NOTES
    Project : Personal Knowledge Platform (PKP)
    Version : 2.0
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ============================================================
# Module Loading
# ============================================================

$ModuleFolder = Join-Path $PSScriptRoot "Modules"

$Modules = @(
    "Utilities.ps1",
    "Discovery.ps1",
    "Validation.ps1",
    "UI.ps1",
    "Build.ps1",
    "RepositoryTransport.ps1",
    "FlatTransport.ps1",
	"ZipTransport.ps1",
    "Reports.ps1",
    "Pipeline.ps1",
    "Processing.ps1"
)

foreach ($Module in $Modules) {
    $ModulePath = Join-Path $ModuleFolder $Module
    if (Test-Path $ModulePath) {
        . $ModulePath
    } else {
        Write-Warning "Module stub missing or empty: $ModulePath"
    }
}

# ============================================================
# Application Startup & Execution Loop
# ============================================================

try {
    Clear-Host
    Show-Banner

    $ScriptFolder = Split-Path -Parent $MyInvocation.MyCommand.Path
    $PKPRoot      = Get-PKPRoot -ScriptFolder $ScriptFolder

    Write-Host "Script Folder :" $ScriptFolder
    Write-Host "PKP Root      :" $PKPRoot
    Write-Host ""

    $DefinitionsFolder = Get-DefinitionsFolder -PKPRoot $PKPRoot
    Write-Host "Definitions   :" $DefinitionsFolder
    Write-Host ""

    $ContextPacks = Get-ContextPacks -DefinitionsFolder $DefinitionsFolder

    if (-not $ContextPacks) {
        Write-Host "========================================="
        Write-Host "No Context Pack definitions were found."
        Write-Host "========================================="
    } else {
        Show-ContextPacks -ContextPacks $ContextPacks
        $Selection = Read-Selection
        Process-Selection -Selection $Selection -ContextPacks $ContextPacks -PKPRoot $PKPRoot
    }
}
catch {
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host " EXCEPTION / ERROR DETECTED" -ForegroundColor Red
    Write-Host "=========================================" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Stack Trace:" -ForegroundColor DarkGray
    Write-Host $_.ScriptStackTrace -ForegroundColor DarkGray
    Write-Host ""

    # Log error to file
    try {
        $LogDir = Join-Path $PSScriptRoot "Logs"
        if (-not (Test-Path $LogDir)) { New-Item -ItemType Directory -Path $LogDir -Force | Out-Null }
        $LogFile = Join-Path $LogDir "ErrorLog.txt"
        $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $ErrorEntry = "[$TimeStamp] ERROR: $($_.Exception.Message)`nStack: $($_.ScriptStackTrace)`n"
        Add-Content -Path $LogFile -Value $ErrorEntry
        Write-Host "Error logged to: $LogFile" -ForegroundColor Cyan
    } catch {
        # Fallback if logging fails
    }
}
finally {
    Write-Host ""
    Read-Host "Press [Enter] to exit..."
}