##=============================================================================
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

$OS = 'Windows 10 Enterprise 21H2'
$Serial = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber

$Global:Command1 = 'Set-Location HKCU:\Console
Set-Location ''%SystemRoot%_System32_WindowsPowerShell_v1.0_Powershell.exe''
Set-ItemProperty . QuickEdit -Value 0x00000000
Set-ItemProperty . FaceName -type STRING -value ''Lucida Console''
Set-ItemProperty . FontSize -type DWORD -value 0x00240000
Set-ItemProperty . FontWeight -type DWORD -value 0x00000190'
Start-Process powershell -ArgumentList "-command invoke-command -scriptblock {$Global:Command1}" -Wait

#=============================================================================
#region FUNCTIONS
#=============================================================================
function Invoke-NewBoxHD {
    <#
    .SYNOPSIS
    Synopsis
    .EXAMPLE
    NewBox
    .INPUTS
    None
    You cannot pipe objects to NewBox.
    .OUTPUTS
    None
    The cmdlet does not return any output.
    #>

    [CmdletBinding()]
    Param()

    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $PopupBox = New-Object system.Windows.Forms.Form
    $PopupBox.ClientSize = New-Object System.Drawing.Point(1300,750)
    $PopupBox.text = 'Hennepin County SSD Team'
    $PopupBox.TopMost = $false
    $PopupBox.Controlbox = $false

    $Title = New-Object system.Windows.Forms.Label
    $Title.text = 'Welcome to Hennepin County Imaging'
    $Title.AutoSize = $true
    $Title.width = 25
    $Title.height = 10
    $Title.location = New-Object System.Drawing.Point(26,34)
    $Title.Font = New-Object System.Drawing.Font('Segoe UI',28,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

    $OSDescription = New-Object system.Windows.Forms.Label
    $OSDescription.text = 'The default Operating System that will be installed is: '
    $OSDescription.AutoSize = $true
    $OSDescription.width = 25
    $OSDescription.height = 10
    $OSDescription.location = New-Object System.Drawing.Point(43,139)
    $OSDescription.Font = New-Object System.Drawing.Font('Segoe UI',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic))

    $OperatingSystemLabel = New-Object system.Windows.Forms.Label
    $OperatingSystemLabel.text = "$OS"
    $OperatingSystemLabel.AutoSize = $true
    $OperatingSystemLabel.width = 25
    $OperatingSystemLabel.height = 10
    $OperatingSystemLabel.location = New-Object System.Drawing.Point(41,183)
    $OperatingSystemLabel.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

    $SerialDescription = New-Object system.Windows.Forms.Label
    $SerialDescription.text = 'This Machines Serial Number is:'
    $SerialDescription.AutoSize = $true
    $SerialDescription.width = 25
    $SerialDescription.height = 10
    $SerialDescription.location = New-Object System.Drawing.Point(41,260)
    $SerialDescription.Font = New-Object System.Drawing.Font('Segoe UI',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic))

    $SerialLabel = New-Object system.Windows.Forms.Label
    $SerialLabel.text = "$Serial"
    $SerialLabel.AutoSize = $true
    $SerialLabel.width = 25
    $SerialLabel.height = 10
    $SerialLabel.location = New-Object System.Drawing.Point(43,300)
    $SerialLabel.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

    $MakeASelection = New-Object system.Windows.Forms.Label
    $MakeASelection.text = 'Please make a selection below:'
    $MakeASelection.AutoSize = $true
    $MakeASelection.width = 25
    $MakeASelection.height = 10
    $MakeASelection.location = New-Object System.Drawing.Point(39,388)
    $MakeASelection.Font = New-Object System.Drawing.Font('Segoe UI',20)

    $OSSelection = New-Object system.Windows.Forms.ListBox
    $OSSelection.text = 'ListBox'
    $OSSelection.width = 500
    $OSSelection.height = 200
    $OSSelection.location = New-Object System.Drawing.Point(30,444)
    $OSSelection.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic))

    [void] $OSSelection.Items.Add('Windows 10 v21H2')
    [void] $OSSelection.Items.Add('HCSO Windows 10 v20H2')
    $OSSelection.SetSelected(0,$true)  > $Null
    $PopupBox.Controls.Add($OSSelection)

    $ExitButton = New-Object system.Windows.Forms.Button
    $ExitButton.text = 'Exit'
    $ExitButton.width = 257
    $ExitButton.height = 43
    $ExitButton.location = New-Object System.Drawing.Point(43,666)
    $ExitButton.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
    $ExitButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    $InstallWindows = New-Object system.Windows.Forms.Button
    $InstallWindows.text = 'Install Windows 10'
    $InstallWindows.width = 500
    $InstallWindows.height = 43
    $InstallWindows.location = New-Object System.Drawing.Point(433,666)
    $InstallWindows.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Underline))
    $InstallWindows.DialogResult = [System.Windows.Forms.DialogResult]::OK

    $PopupBox.controls.AddRange(@($InstallWindows,$Title,$OSDescription,$OperatingSystemLabel,$SerialDescription,$SerialLabel,$OSSelection,$MakeASelection,$ExitButton))
    $Result = $PopupBox.ShowDialog()

    If ($Result -eq [System.Windows.Forms.DialogResult]::OK) {
        $Selection = $OSSelection.SelectedItem

        if ($Selection -eq 'Windows 10 v21H2') {
            $global:WIN10 = 'v21H2'
            $global:WIN10ALT = $Null
        }

        if ($Selection -eq 'HCSO Windows 10 v20H2') {
            $global:WIN10ALT = 'v20H2'
            $global:WIN10 = $Null
        }
    }
}

function Invoke-NewBox4k {
    <#
    .SYNOPSIS
    Synopsis
    .EXAMPLE
    NewBox
    .INPUTS
    None
    You cannot pipe objects to NewBox.
    .OUTPUTS
    None
    The cmdlet does not return any output.
    #>

    [CmdletBinding()]
    Param()


    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $PopupBox = New-Object system.Windows.Forms.Form
    $PopupBox.ClientSize = New-Object System.Drawing.Point(2400,1450)
    $PopupBox.text = 'Hennepin County SSD Team'
    $PopupBox.TopMost = $false
    $PopupBox.Controlbox = $false

    $Title = New-Object system.Windows.Forms.Label
    $Title.text = 'Welcome to Hennepin County Imaging'
    $Title.AutoSize = $true
    $Title.width = 25
    $Title.height = 10
    $Title.location = New-Object System.Drawing.Point(26,34)
    $Title.Font = New-Object System.Drawing.Font('Segoe UI',28,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

    $OSDescription = New-Object system.Windows.Forms.Label
    $OSDescription.text = 'The default Operating System that will be installed is: '
    $OSDescription.AutoSize = $true
    $OSDescription.width = 25
    $OSDescription.height = 10
    $OSDescription.location = New-Object System.Drawing.Point(43,250)
    $OSDescription.Font = New-Object System.Drawing.Font('Segoe UI',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic))

    $OperatingSystemLabel = New-Object system.Windows.Forms.Label
    $OperatingSystemLabel.text = "$OS"
    $OperatingSystemLabel.AutoSize = $true
    $OperatingSystemLabel.width = 25
    $OperatingSystemLabel.height = 10
    $OperatingSystemLabel.location = New-Object System.Drawing.Point(41,350)
    $OperatingSystemLabel.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

    $SerialDescription = New-Object system.Windows.Forms.Label
    $SerialDescription.text = 'This Machines Serial Number is:'
    $SerialDescription.AutoSize = $true
    $SerialDescription.width = 25
    $SerialDescription.height = 10
    $SerialDescription.location = New-Object System.Drawing.Point(41,500)
    $SerialDescription.Font = New-Object System.Drawing.Font('Segoe UI',14,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic))

    $SerialLabel = New-Object system.Windows.Forms.Label
    $SerialLabel.text = "$Serial"
    $SerialLabel.AutoSize = $true
    $SerialLabel.width = 25
    $SerialLabel.height = 10
    $SerialLabel.location = New-Object System.Drawing.Point(43,600)
    $SerialLabel.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

    $MakeASelection = New-Object system.Windows.Forms.Label
    $MakeASelection.text = 'Please make a selection below:'
    $MakeASelection.AutoSize = $true
    $MakeASelection.width = 25
    $MakeASelection.height = 10
    $MakeASelection.location = New-Object System.Drawing.Point(39,830)
    $MakeASelection.Font = New-Object System.Drawing.Font('Segoe UI',20)

    $OSSelection = New-Object system.Windows.Forms.ListBox
    $OSSelection.text = 'ListBox'
    $OSSelection.width = 1000
    $OSSelection.height = 400
    $OSSelection.location = New-Object System.Drawing.Point(30,950)
    $OSSelection.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic))

    [void] $OSSelection.Items.Add('Windows 10 v21H2')
    [void] $OSSelection.Items.Add('HCSO Windows 10 v20H2')
    $OSSelection.SetSelected(0,$true)  > $Null
    $PopupBox.Controls.Add($OSSelection)

    $ExitButton = New-Object system.Windows.Forms.Button
    $ExitButton.text = 'Exit'
    $ExitButton.width = 257
    $ExitButton.height = 100
    $ExitButton.location = New-Object System.Drawing.Point(43,1300)
    $ExitButton.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))
    $ExitButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

    $InstallWindows = New-Object system.Windows.Forms.Button
    $InstallWindows.text = 'Install Windows 10'
    $InstallWindows.width = 1000
    $InstallWindows.height = 100
    $InstallWindows.location = New-Object System.Drawing.Point(433,1300)
    $InstallWindows.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold -bor [System.Drawing.FontStyle]::Underline))
    $InstallWindows.DialogResult = [System.Windows.Forms.DialogResult]::OK

    $PopupBox.controls.AddRange(@($InstallWindows,$Title,$OSDescription,$OperatingSystemLabel,$SerialDescription,$SerialLabel,$MakeASelection,$OSSelection,$ExitButton))
    $Result = $PopupBox.ShowDialog()

    If ($Result -eq [System.Windows.Forms.DialogResult]::OK) {
        $Selection = $OSSelection.SelectedItem

        if ($Selection -eq 'Windows 10 v21H2') {
            $global:WIN10 = 'v21H2'
            $global:WIN10ALT = $Null
        }

        if ($Selection -eq 'HCSO Windows 10 v20H2') {
            $global:WIN10ALT = 'v20H2'
            $global:WIN10 = $Null
        }
    }
}



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

    if ((Get-MyComputerModel) -match 'TWR') {
        Write-Host -ForegroundColor Cyan 'Setting Display Resolution to 1080p'
        Set-DisRes 1080p
    }

    Add-Type -AssemblyName System.Windows.Forms
    $Monitors = [System.Windows.Forms.Screen]::AllScreens
    foreach ($Monitor in $Monitors) {
        $Width = $Monitor.bounds.Width
    }

    If ($Width -eq '3840') {
        Invoke-NewBox4K
    }

    Else {
        Invoke-NewBoxHD
    }
}

#=============================================================================
#endregion
#=============================================================================
#region EXECUTION
#=============================================================================

Invoke-OSDCloud
If ($global:WIN10 -eq 'v21H2') {
    Write-Host -ForegroundColor Cyan 'Selected v21H2'
    $Global:Command = 'Start-OSDCloud -OSLanguage en-us -OSBuild 21H2 -OSEdition Enterprise -ZTI'
    Start-Process powershell -ArgumentList "-command invoke-command -scriptblock {$Global:Command}" -Wait

} Elseif ($global:WIN10ALT -eq 'v20H2') {
    Write-Host -ForegroundColor Cyan 'Selected v20H2'
    $Global:Command = 'Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI'
    Start-Process powershell -ArgumentList "-command invoke-command -scriptblock {$Global:Command}" -Wait
}

#Creating Different Support scripts
If (Test-Path 'C:\OSDCloud\') {
    $PSCodeHCGG = '
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose
Install-Script -Name Get-WindowsAutoPilotInfo -Verbose
Get-Module Microsoft.Graph.Intune -Verbose
Get-WindowsAutopilotInfo.ps1 -Online -GroupTag HCGG -Verbose
'
    New-Item -Path 'C:\OSDCloud\' -Name AddHCGG.ps1 -Value "$PSCodeHCGG" -Force

    $PSCodeHCSO = '
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose
Install-Script -Name Get-WindowsAutoPilotInfo -Verbose
Get-Module Microsoft.Graph.Intune -Verbose
Get-WindowsAutopilotInfo.ps1 -Online -GroupTag HCSO -Verbose
'
    New-Item -Path 'C:\OSDCloud\' -Name AddHCSO.ps1 -Value "$PSCodeHCSO" -Force

    $PSCodeLIBACF = '
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose
Install-Script -Name Get-WindowsAutoPilotInfo -Verbose
Get-Module Microsoft.Graph.Intune -Verbose
Get-WindowsAutopilotInfo.ps1 -Online -GroupTag LIBACF -Verbose
'
    New-Item -Path 'C:\OSDCloud\' -Name AddLIBACF.ps1 -Value "$PSCodeLIBACF" -Force

    $PSCodeAp = '
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted -Verbose
Install-Script -Name Get-AutopilotDiagnostics -Verbose
Get-Module Microsoft.Graph.Intune -Verbose
Get-AutopilotDiagnostics -Online -Verbose
'
    New-Item -Path 'C:\OSDCloud\' -Name Ap.ps1 -Value "$PSCodeAp" -Force
}

#Restart from WinPE
Write-Host -ForegroundColor Cyan 'Restarting in 20 seconds!'
Start-Sleep -Seconds 20
wpeutil reboot

#=============================================================================
#endregion
#=============================================================================
