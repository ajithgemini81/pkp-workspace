<#
.SYNOPSIS
    PKP Context Pack Generator - Utility Functions

.DESCRIPTION
    Common reusable helper functions used across the
    Context Pack Generator modules.

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : Utilities
    Version : 2.0
#>


# ============================================================
# Path Utilities
# ============================================================

function Ensure-Folder
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (-not (Test-Path $Path))
    {
        New-Item `
            -ItemType Directory `
            -Path $Path `
            -Force | Out-Null
    }
}


function Remove-FolderIfExists
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Path
    )

    if (Test-Path $Path)
    {
        Remove-Item `
            -Path $Path `
            -Recurse `
            -Force | Out-Null
    }
}


function Get-RelativePath
{
    param
    (
        [Parameter(Mandatory)]
        [string]$BasePath,

        [Parameter(Mandatory)]
        [string]$FullPath
    )


    $BaseUri = New-Object System.Uri(
        ($BasePath.TrimEnd('\') + '\')
    )

    $FullUri = New-Object System.Uri(
        $FullPath
    )


    $RelativePath = $BaseUri.MakeRelativeUri(
        $FullUri
    ).ToString()


    return $RelativePath.Replace(
        '/',
        '\'
    )
}


# ============================================================
# File Utilities
# ============================================================

function Get-FileNameWithoutExtension
{
    param
    (
        [Parameter(Mandatory)]
        [string]$FileName
    )


    return [System.IO.Path]::GetFileNameWithoutExtension(
        $FileName
    )
}


function Get-FileExtension
{
    param
    (
        [Parameter(Mandatory)]
        [string]$FileName
    )


    return [System.IO.Path]::GetExtension(
        $FileName
    )
}


function Test-FileExists
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Path
    )


    return Test-Path `
        -Path $Path `
        -PathType Leaf
}


# ============================================================
# Text Utilities
# ============================================================

function Write-Utf8File
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [array]$Content
    )


    Set-Content `
        -Path $Path `
        -Value $Content `
        -Encoding UTF8
}


function Add-MarkdownHeading
{
    param
    (
        [Parameter(Mandatory)]
        [array]$Lines,

        [Parameter(Mandatory)]
        [string]$Heading,

        [Parameter(Mandatory)]
        [int]$Level
    )


    $Prefix = "#" * $Level

    $Lines += "$Prefix $Heading"
    $Lines += ""

    return $Lines
}


# ============================================================
# Collection Utilities
# ============================================================

function Test-CollectionEmpty
{
    param
    (
        [array]$Collection
    )


    return (
        $null -eq $Collection -or
        $Collection.Count -eq 0
    )
}


function Add-UniqueItem
{
    param
    (
        [array]$Collection,

        [string]$Item
    )


    if ($Collection -notcontains $Item)
    {
        $Collection += $Item
    }


    return $Collection
}


# ============================================================
# Console Utilities
# ============================================================

function Write-Section
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Title
    )


    Write-Host ""
    Write-Host $Title
    Write-Host ("-" * $Title.Length)
    Write-Host ""
}


function Write-Success
{
    param
    (
        [string]$Message
    )


    Write-Host "[SUCCESS] $Message"
}


function Write-Info
{
    param
    (
        [string]$Message
    )


    Write-Host "[INFO]    $Message"
}


function Write-WarningMessage
{
    param
    (
        [string]$Message
    )


    Write-Host "[WARNING] $Message"
}


function Write-ErrorMessage
{
    param
    (
        [string]$Message
    )


    Write-Host "[ERROR]   $Message"
}