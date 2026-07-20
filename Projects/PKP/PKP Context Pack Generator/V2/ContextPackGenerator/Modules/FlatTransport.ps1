<#
.SYNOPSIS
    PKP Context Pack Generator - Flat Transport

.DESCRIPTION
    Converts Repository Transport Packages into Flat Packages.

    Flat Packages are optimized for AI tools that cannot
    understand folder structures during upload.

    Original repository hierarchy is preserved through INDEX.md.

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : FlatTransport
    Version : 2.0
#>


# ============================================================
# Flat Transport Builder
# ============================================================

function Build-FlatTransport
{
    param
    (
        [Parameter(Mandatory)]
        [PSCustomObject]$ContextPack,

        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    Write-Host ""
    Write-Host "Building Flat Transport..."
    Write-Host ""


    if (-not $ContextPack.Success)
    {
        return [PSCustomObject]@{

            Success = $false

            Transport = "Flat"

            Folder = $null
        }
    }


    $FlatRoot = Get-FlatOutputFolder `
        -PKPRoot $PKPRoot


    $FlatFolder = New-FlatFolder `
        -OutputFolder $FlatRoot `
        -ContextPackName $ContextPack.ContextPackName


    $Result = Build-FlatPackage `
        -RepositoryFolder $ContextPack.RepositoryFolder `
        -FlatFolder $FlatFolder



    return [PSCustomObject]@{

        Success = $Result.Success

        Transport = "Flat"

        Folder = $FlatFolder

        IndexFile = $Result.IndexFile

        Renames = $Result.Renames

        ContextPackName = $ContextPack.ContextPackName
    }
}



# ============================================================
# Flat Folder Creation
# ============================================================

function New-FlatFolder
{
    param
    (
        [Parameter(Mandatory)]
        [string]$OutputFolder,

        [Parameter(Mandatory)]
        [string]$ContextPackName
    )


    $Folder = Join-Path `
        $OutputFolder `
        $ContextPackName


    Remove-FolderIfExists `
        -Path $Folder


    Ensure-Folder `
        -Path $Folder


    return $Folder
}



# ============================================================
# Flat Package Builder
# ============================================================

function Build-FlatPackage
{
    param
    (
        [Parameter(Mandatory)]
        [string]$RepositoryFolder,

        [Parameter(Mandatory)]
        [string]$FlatFolder
    )


    Write-Host "Scanning Repository Package..."



    $Files = Get-FlatFileList `
        -RepositoryFolder $RepositoryFolder



    $Mappings = Resolve-FlatFilenameCollisions `
        -Files $Files



    Copy-FlatFiles `
        -Mappings $Mappings `
        -FlatFolder $FlatFolder



    $IndexFile = Write-FlatIndex `
        -FlatFolder $FlatFolder `
        -Mappings $Mappings



    return [PSCustomObject]@{

        Success = $true

        IndexFile = $IndexFile

        Renames = (
            $Mappings |
            Where-Object {
                $_.WasRenamed
            }
        )
    }
}



# ============================================================
# File Discovery
# ============================================================

function Get-FlatFileList
{
    param
    (
        [Parameter(Mandatory)]
        [string]$RepositoryFolder
    )


    Get-ChildItem `
        -Path $RepositoryFolder `
        -File `
        -Recurse
}



# ============================================================
# Collision Detection
# ============================================================

function Resolve-FlatFilenameCollisions
{
    param
    (
        [Parameter(Mandatory)]
        [array]$Files
    )


    $Mappings = @()


    $Groups = $Files |
        Group-Object Name



    foreach ($File in $Files)
    {

        $CollisionGroup = $Groups |
            Where-Object {
                $_.Name -eq $File.Name
            }



        if ($CollisionGroup.Count -eq 1)
        {
            $FlatName = $File.Name

            $Renamed = $false
        }
        else
        {
            $FlatName = Get-UniqueFlatFilename `
                -File $File `
                -ExistingMappings $Mappings

            $Renamed = (
                $FlatName -ne $File.Name
            )
        }



        $Mappings += [PSCustomObject]@{

            OriginalPath = $File.FullName

            RepositoryPath = (
                Get-RelativePath `
                    -BasePath $File.Directory.Parent.FullName `
                    -FullPath $File.FullName
            )

            OriginalName = $File.Name

            FlatName = $FlatName

            WasRenamed = $Renamed
        }
    }


    return $Mappings
}



# ============================================================
# Filename Resolver
# ============================================================

function Get-UniqueFlatFilename
{
    param
    (
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$File,

        [Parameter(Mandatory)]
        [array]$ExistingMappings
    )


    $DirectoryParts = $File.DirectoryName.Split(
        '\'
    )


    for ($i = $DirectoryParts.Length - 1; $i -ge 0; $i--)
    {

        $Prefix = $DirectoryParts[$i]


        $Candidate =
            "$Prefix - $($File.Name)"



        if (
            $ExistingMappings.FlatName -notcontains $Candidate
        )
        {
            return $Candidate
        }
    }


    $Counter = 1


    do
    {
        $Candidate =
            "$Counter - $($File.Name)"

        $Counter++

    }
    while (
        $ExistingMappings.FlatName -contains $Candidate
    )


    return $Candidate
}



# ============================================================
# Flat File Copy
# ============================================================

function Copy-FlatFiles
{
    param
    (
        [Parameter(Mandatory)]
        [array]$Mappings,

        [Parameter(Mandatory)]
        [string]$FlatFolder
    )


    foreach ($Mapping in $Mappings)
    {

        $Destination =
            Join-Path `
                $FlatFolder `
                $Mapping.FlatName



        Copy-Item `
            -Path $Mapping.OriginalPath `
            -Destination $Destination `
            -Force


        Write-Host `
            "[COPY] $($Mapping.FlatName)"
    }
}



# ============================================================
# INDEX.md Generator
# ============================================================

function Write-FlatIndex
{
    param
    (
        [Parameter(Mandatory)]
        [string]$FlatFolder,

        [Parameter(Mandatory)]
        [array]$Mappings
    )


    $File =
        Join-Path `
            $FlatFolder `
            "INDEX.md"



    $Lines = @()


    $Lines += "# Flat Package Index"
    $Lines += ""

    $Lines += "Generated:"
    $Lines += (
        Get-Date `
            -Format "yyyy-MM-dd HH:mm:ss"
    )

    $Lines += ""

    $Lines += "---"

    $Lines += ""

    $Lines += "## Files"

    $Lines += ""

    $Lines += "| Flat Filename | Original Path |"

    $Lines += "|---|---|"



    foreach ($Mapping in $Mappings)
    {
        $Lines +=
            "| $($Mapping.FlatName) | $($Mapping.OriginalPath) |"
    }



    $Lines += ""

    $Lines += "---"

    $Lines += ""

    $Lines += "## Rename Mapping"

    $Lines += ""

    $Lines += "| Original | Flat Filename |"

    $Lines += "|---|---|"



    foreach (
        $Mapping in $Mappings |
        Where-Object {
            $_.WasRenamed
        }
    )
    {
        $Lines +=
            "| $($Mapping.OriginalName) | $($Mapping.FlatName) |"
    }



    Set-Content `
        -Path $File `
        -Value $Lines `
        -Encoding UTF8


    return $File
}