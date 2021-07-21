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
        Set-DisRes 1600
    }

    if ((Get-MyComputerProduct) -match '857F') {
        Write-Host -ForegroundColor Cyan 'Setting Font to 36x'
        Set-Location 'HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe'
        Set-ItemProperty . FaceName -type STRING -Value 'Lucida Console' -Force
        Set-ItemProperty . FontFamily -type DWORD -Value 0x00000036 -Force
        Set-ItemProperty . FontSize -type DWORD -Value 0x00240000 -Force
        Set-ItemProperty . FontWeight -type DWORD -Value 0x00000190 -Force
    }

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = 'Hennepin County SSD'
    $Form.controlbox = $false;
    $form.Size = New-Object System.Drawing.Size(420,200)
    $form.StartPosition = 'CenterScreen'
    $Font = New-Object System.Drawing.Font('Segoe UI',14)
    $Form.Font = $Font

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(150,120)
    $okButton.Size = New-Object System.Drawing.Size(180,30)
    $okButton.Text = 'Install Windows 10'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(75,120)
    $cancelButton.Size = New-Object System.Drawing.Size(75,30)
    $cancelButton.Text = 'Exit'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(420,30)
    $label.Text = 'Windows 10 Enterprise 20H2'
    $form.Controls.Add($label)

    $label1 = New-Object System.Windows.Forms.Label
    $label1.Location = New-Object System.Drawing.Point(10,60)
    $label1.Size = New-Object System.Drawing.Size(420,20)
    $label1.Text = 'Please make a selection below:'
    $form.Controls.Add($label1)
    $form.Topmost = $true
    $Result = $form.ShowDialog()
    If ($Result -eq 'OK') {
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
$shell = New-Object -ComObject "Shell.Application"
$shell.minimizeall()
Invoke-OSDCloud
$shell = New-Object -ComObject "Shell.Application"
$shell.undominimizeall()
#Restart from WinPE
Write-Host -ForegroundColor Cyan 'Restarting in 20 seconds!'
Start-Sleep -Seconds 20
wpeutil reboot

#=============================================================================
#endregion
#=============================================================================
