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

    if ((Get-MyComputerModel) -match 'Virtual') {
        Write-Host -ForegroundColor Cyan 'Setting Display Resolution to 1600x'
        #Set-DisRes 1600
        Set-DisRes 1080p
    }

    $Serial = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $PopupBox = New-Object system.Windows.Forms.Form
    $PopupBox.ClientSize = New-Object System.Drawing.Point(737,347)
    $PopupBox.text = 'Hennepin County SSD Team'
    $PopupBox.TopMost = $true
    $PopupBox.Controlbox = $false

    $Title = New-Object system.Windows.Forms.Label
    $Title.text = 'Welcome to Hennepin County Imaging'
    $Title.AutoSize = $true
    $Title.width = 25
    $Title.height = 10
    $Title.location = New-Object System.Drawing.Point(20,11)
    $Title.Font = New-Object System.Drawing.Font('Segoe UI',28,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

    $OSDescription = New-Object system.Windows.Forms.Label
    $OSDescription.text = 'The following Operating System will be installed: '
    $OSDescription.AutoSize = $true
    $OSDescription.width = 25
    $OSDescription.height = 10
    $OSDescription.location = New-Object System.Drawing.Point(32,73)
    $OSDescription.Font = New-Object System.Drawing.Font('Segoe UI',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic))

    $OperatingSystemLabel = New-Object system.Windows.Forms.Label
    $OperatingSystemLabel.text = 'Windows 10 Enterprise 20H2'
    $OperatingSystemLabel.AutoSize = $true
    $OperatingSystemLabel.width = 25
    $OperatingSystemLabel.height = 10
    $OperatingSystemLabel.location = New-Object System.Drawing.Point(40,103)
    $OperatingSystemLabel.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

    $SerialDescription = New-Object system.Windows.Forms.Label
    $SerialDescription.text = 'This Machines Serial Number is:'
    $SerialDescription.AutoSize = $true
    $SerialDescription.width = 25
    $SerialDescription.height = 10
    $SerialDescription.location = New-Object System.Drawing.Point(33,141)
    $SerialDescription.Font = New-Object System.Drawing.Font('Segoe UI',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic))

    $SerialLabel = New-Object system.Windows.Forms.Label
    $SerialLabel.text = "$Serial"
    $SerialLabel.AutoSize = $true
    $SerialLabel.width = 25
    $SerialLabel.height = 10
    $SerialLabel.location = New-Object System.Drawing.Point(40,175)
    $SerialLabel.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

    $MakeASelection = New-Object system.Windows.Forms.Label
    $MakeASelection.text = 'Please make a selection below:'
    $MakeASelection.AutoSize = $true
    $MakeASelection.width = 25
    $MakeASelection.height = 10
    $MakeASelection.location = New-Object System.Drawing.Point(33,238)
    $MakeASelection.Font = New-Object System.Drawing.Font('Segoe UI',20)

    $ExitButton = New-Object system.Windows.Forms.Button
    $ExitButton.text = 'Exit'
    $ExitButton.width = 257
    $ExitButton.height = 43
    $ExitButton.location = New-Object System.Drawing.Point(32,283)
    $ExitButton.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
    $ExitButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    $InstallWindows = New-Object system.Windows.Forms.Button
    $InstallWindows.text = 'Install Windows 10'
    $InstallWindows.width = 263
    $InstallWindows.height = 43
    $InstallWindows.location = New-Object System.Drawing.Point(319,283)
    $InstallWindows.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Underline))
    $InstallWindows.DialogResult = [System.Windows.Forms.DialogResult]::OK

    $PopupBox.controls.AddRange(@($InstallWindows,$Title,$OSDescription,$OperatingSystemLabel,$SerialDescription,$SerialLabel,$MakeASelection,$ExitButton))
    $Result = $PopupBox.ShowDialog()

    If ($Result -eq [System.Windows.Forms.DialogResult]::OK) {
        #Installing latest OSD Content
        Write-Host -ForegroundColor Cyan 'Updating OSD PowerShell Module'
        Install-Module OSD -Force

        Write-Host -ForegroundColor Cyan 'Importing OSD PowerShell Module'
        Import-Module OSD -Force
        Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI
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
