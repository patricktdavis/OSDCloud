#=============================================================================
#region SCRIPT DETAILS
#=============================================================================

<#
.SYNOPSIS
Runs a menu on OSDCloud allowing techs to deploy a machine with Chosen Enterprise image

.EXAMPLE
PS C:\> OSDCloud-Hennepin.ps1
#>

#=============================================================================
#endregion
#=============================================================================

#=============================================================================
#region FUNCTIONS
#=============================================================================

function Invoke-OSDCloud {
    <#
    .SYNOPSIS
    Synopsis

    .EXAMPLE
    Invoke-OSDCloud

    .INPUTS
    None
    You cannot pipe objects to Invoke-OSDCloud.

    .OUTPUTS
    None
    The cmdlet does not return any output.
    #>

    [CmdletBinding()]
    Param()

    #Change Display Resolution for Virtual Machine
    if ((Get-MyComputerModel) -match 'Virtual') {
        Write-Host -ForegroundColor Cyan 'Setting Display Resolution to 1600x'
        Set-DisRes 1600
    }


    if ((Get-MyComputerProduct) -match '857F') {
        Write-Host -ForegroundColor Cyan 'Setting Font to 36x'
        Set-Location HKCU:\Console
        New-Item '.\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'
        Set-Location '.\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'
        New-ItemProperty . FaceName -type STRING -Value 'Lucida Console'
        New-ItemProperty . FontFamily -type DWORD -Value 0x00000036
        New-ItemProperty . FontSize -type DWORD -Value 0x00240000
        New-ItemProperty . FontWeight -type DWORD -Value 0x00000190
    }

    Write-Host -ForegroundColor Cyan "Starting Hennepin County's Custom OSDCloud ..."
    Start-Sleep -Seconds 5
    Clear-Host
    Write-Host '===================== Main Menu ===========================' -ForegroundColor Yellow
    Write-Host '================== Hennepin County SSD ====================' -ForegroundColor Yellow
    Write-Host '== Please Put in a Assyst ticket if there are any issues ==' -ForegroundColor Yellow
    Write-Host '===========================================================' -ForegroundColor Yellow
    Write-Host '1: Zero-Touch Win10 20H2 | English | Enterprise'-ForegroundColor Yellow
    Write-Host "2: Exit`n"-ForegroundColor Yellow
    $OSDinput = Read-Host 'Please make a selection'

    #Installing latest OSD Content
    Write-Host -ForegroundColor Cyan 'Updating OSD PowerShell Module'
    Install-Module OSD -Force

    Write-Host -ForegroundColor Cyan 'Importing OSD PowerShell Module'
    Import-Module OSD -Force

    #Start OSDCloud
    Write-Host -ForegroundColor Cyan 'Start Deploying the machine with the following selections'
    switch ($OSDinput) {
        '1' { Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI }
        '2' { Exit }
    }
}

#=============================================================================
#endregion
#=============================================================================
#region EXECUTION
#=============================================================================

Invoke-OSDCloud
#Restart from WinPE
Write-Host -ForegroundColor Cyan 'Restarting in 20 seconds!'
Start-Sleep -Seconds 20
wpeutil reboot

#=============================================================================
#endregion
#=============================================================================
