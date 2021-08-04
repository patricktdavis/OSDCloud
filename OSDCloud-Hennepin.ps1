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

$OS = 'Windows 10 Enterprise 20H2'
$Serial = (Get-CimInstance -ClassName Win32_BIOS).SerialNumber
<#$Windows = 'Windows 10'
If (Test-Path -Path 'C:\Windows\System32\kernel32.dll') {
    $Edition = (Get-WindowsEdition -Path c:\).edition
    Function Invoke-OSVersion {

        $signature = @'
[DllImport("kernel32.dll")]
public static extern uint GetVersion();
'@
        Add-Type -MemberDefinition $signature -Name 'Win32OSVersion' -Namespace Win32Functions -PassThru
    }
    $OSBuild = [System.BitConverter]::GetBytes((Invoke-OSVersion)::GetVersion())
    $Build = [byte]$OSBuild[2],[byte]$OSBuild[3]
    $BuildNumber = [System.BitConverter]::ToInt16($build,0)

    if ($BuildNumber -eq '19042') {
        $InstalledBuild = '20H2'
    } elseif ($BuildNumber -eq '19041') {
        $InstalledBuild = '20H2'
    } elseif ($BuildNumber -eq '18363') {
        $InstalledBuild = '1909'
    } elseif ($BuildNumber -eq '18362') {
        $InstalledBuild = '1903'
    } elseif ($BuildNumber -eq '17763') {
        $InstalledBuild = '1809'
    } elseif ($BuildNumber -eq '17134') {
        $InstalledBuild = '1803'
    } elseif ($BuildNumber -eq '16299') {
        $InstalledBuild = '1709'
    }
} else {
    $InstalledBuild = 'Installed'
    $Edition = 'No OS'
    $Windows = ''
}#>

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
    $OSSelection.width = 400
    $OSSelection.height = 200
    $OSSelection.location = New-Object System.Drawing.Point(30,444)
    $OSSelection.Font = New-Object System.Drawing.Font('Segoe UI',20,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic))

    [void] $OSSelection.Items.Add('Windows 10 v20H2')
    [void] $OSSelection.Items.Add('Windows 10 v1909')
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
        #Installing latest OSD Content
        Write-Host -ForegroundColor Cyan 'Updating OSD PowerShell Module'
        Install-Module OSD -Force

        Write-Host -ForegroundColor Cyan 'Importing OSD PowerShell Module'
        Import-Module OSD -Force

        if ($Selection -eq 'Windows 10 v20H2') {
            Write-Host '20h2'
            Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI
        }

        if ($Selection -eq 'Windows 10 v1909') {
            Write-Host '1909'
            Start-OSDCloud -OSLanguage en-us -OSBuild 1909 -OSEdition Enterprise -ZTI
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

    [void] $OSSelection.Items.Add('Windows 10 v20H2')
    [void] $OSSelection.Items.Add('Windows 10 v1909')
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
        #Installing latest OSD Content
        Write-Host -ForegroundColor Cyan 'Updating OSD PowerShell Module'
        Install-Module OSD -Force

        Write-Host -ForegroundColor Cyan 'Importing OSD PowerShell Module'
        Import-Module OSD -Force

        if ($Selection -eq 'Windows 10 v20H2') {
            Write-Host '20h2'
            Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI
        }

        if ($Selection -eq 'Windows 10 v1909') {
            Write-Host '1909'
            Start-OSDCloud -OSLanguage en-us -OSBuild 1909 -OSEdition Enterprise -ZTI
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
#Restart from WinPE
Write-Host -ForegroundColor Cyan 'Restarting in 20 seconds!'
Start-Sleep -Seconds 20
wpeutil reboot

#=============================================================================
#endregion
#=============================================================================
