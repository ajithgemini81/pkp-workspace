<#
.SYNOPSIS
    PKP Context Pack Generator - Processing Functions

.DESCRIPTION
    Handles user selections and coordinates Context Pack
    generation workflows.

.NOTES
    Project : Personal Knowledge Platform (PKP)
    Module  : Processing
    Version : 2.0
#>


# ============================================================
# Selection Processing
# ============================================================

function Process-Selection
{
    param
    (
        [Parameter(Mandatory)]
        [string]$Selection,

        [Parameter(Mandatory)]
        [array]$ContextPacks,

        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    $Selection = $Selection.ToUpper()



    if ($Selection -eq "Q")
    {
        Write-Host "Exiting..."

        return
    }



    if ($Selection -eq "A")
    {
        Build-AllContextPacks `
            -ContextPacks $ContextPacks `
            -PKPRoot $PKPRoot

        return
    }



    [int]$SelectedIndex = 0


    if (-not [int]::TryParse(
        $Selection,
        [ref]$SelectedIndex
    ))
    {
        Write-Host ""

        Write-Host "Invalid selection."

        return
    }



    $SelectedContextPack =
        Get-SelectedContextPack `
            -SelectedIndex $SelectedIndex `
            -ContextPacks $ContextPacks



    if ($null -eq $SelectedContextPack)
    {
        Write-Host ""

        Write-Host "Selection out of range."

        return
    }



    Build-And-DisplayContextPack `
        -ManifestFile $SelectedContextPack `
        -PKPRoot $PKPRoot
}



# ============================================================
# Single Context Pack Build
# ============================================================

function Build-And-DisplayContextPack
{
    param
    (
        [Parameter(Mandatory)]
        [System.IO.FileInfo]$ManifestFile,

        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    Show-BuildStarted `
        -ContextPackName $ManifestFile.BaseName



    $Build =
        Build-ContextPack `
            -ManifestFile $ManifestFile `
            -PKPRoot $PKPRoot



    if (-not $Build.Success)
    {
        Show-ApplicationError `
            -Message "Context Pack build failed."

        return
    }



    # --------------------------------------------------------
    # Repository Transport
    # --------------------------------------------------------

    $RepositoryTransport =
        Build-RepositoryTransport `
            -ContextPack $Build



    # --------------------------------------------------------
    # Flat Transport
    # --------------------------------------------------------

    $FlatTransport =
        Build-FlatTransport `
            -ContextPack $Build `
            -PKPRoot $PKPRoot



    # --------------------------------------------------------
    # ZIP Transport
    # --------------------------------------------------------

    $ZipTransport =
        Build-ZipTransport `
            -TransportPackage $FlatTransport `
            -PKPRoot $PKPRoot



    Write-BuildResult `
        -Build $Build `
        -Repository $RepositoryTransport `
        -Flat $FlatTransport `
        -Zip $ZipTransport



    Show-BuildCompleted `
        -ContextPackName $Build.ContextPackName
}



# ============================================================
# Build ALL Context Packs
# ============================================================

function Build-AllContextPacks
{
    param
    (
        [Parameter(Mandatory)]
        [array]$ContextPacks,

        [Parameter(Mandatory)]
        [string]$PKPRoot
    )


    Write-Host ""

    Write-Host "Generating ALL Context Packs..."

    Write-Host ""



    foreach ($Pack in $ContextPacks)
    {

        Show-BuildStarted `
            -ContextPackName $Pack.BaseName



        $Build =
            Build-ContextPack `
                -ManifestFile $Pack `
                -PKPRoot $PKPRoot



        if ($Build.Success)
        {

            $Repository =
                Build-RepositoryTransport `
                    -ContextPack $Build



            $Flat =
                Build-FlatTransport `
                    -ContextPack $Build `
                    -PKPRoot $PKPRoot



            $Zip =
                Build-ZipTransport `
                    -TransportPackage $Flat `
                    -PKPRoot $PKPRoot



            Write-Success `
                "$($Pack.BaseName) completed."

        }
        else
        {
            Write-WarningMessage `
                "$($Pack.BaseName) failed."
        }


        Write-Host ""
    }



    Write-Host "Finished building all Context Packs."
}



# ============================================================
# Result Display
# ============================================================

function Write-BuildResult
{
    param
    (
        [Parameter(Mandatory)]
        [PSCustomObject]$Build,

        [PSCustomObject]$Repository,

        [PSCustomObject]$Flat,

        [PSCustomObject]$Zip
    )


    Write-Host ""

    Write-Host "Build Result"

    Write-Host "------------"

    Write-Host ""


    Write-Host "Context Pack:"
    Write-Host $Build.ContextPackName

    Write-Host ""



    Write-Host "Repository Package:"
    Write-Host $Repository.Folder

    Write-Host ""



    Write-Host "Flat Package:"
    Write-Host $Flat.Folder

    Write-Host ""



    Write-Host "ZIP Archive:"
    Write-Host $Zip.Archive

    Write-Host ""
}