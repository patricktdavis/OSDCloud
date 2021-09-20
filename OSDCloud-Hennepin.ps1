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

#turning off quick edit
Set-Location HKCU:\Console
Set-Location ‘.%SystemRoot%_System32_WindowsPowerShell_v1.0_Powershell.exe’
Set-ItemProperty . QuickEdit –Value 0x00000000
Pop-Location

# C# needed for Set-ConsoleFont function
if (-not ('Windows.Native.Kernel32' -as [type])) {
    Add-Type -TypeDefinition @'
    namespace Windows.Native
    {
      using System;
      using System.ComponentModel;
      using System.IO;
      using System.Runtime.InteropServices;

      public class Kernel32
      {
        // Constants
        ////////////////////////////////////////////////////////////////////////////
        public const uint FILE_SHARE_READ = 1;
        public const uint FILE_SHARE_WRITE = 2;
        public const uint GENERIC_READ = 0x80000000;
        public const uint GENERIC_WRITE = 0x40000000;
        public static readonly IntPtr INVALID_HANDLE_VALUE = new IntPtr(-1);
        public const int STD_ERROR_HANDLE = -12;
        public const int STD_INPUT_HANDLE = -10;
        public const int STD_OUTPUT_HANDLE = -11;

        // Structs
        ////////////////////////////////////////////////////////////////////////////
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public class CONSOLE_FONT_INFOEX
        {
          private int cbSize;
          public CONSOLE_FONT_INFOEX()
          {
            this.cbSize = Marshal.SizeOf(typeof(CONSOLE_FONT_INFOEX));
          }

          public int FontIndex;
          public short FontWidth;
          public short FontHeight;
          public int FontFamily;
          public int FontWeight;
          [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
          public string FaceName;
        }

        public class Handles
        {
          public static readonly IntPtr StdIn = GetStdHandle(STD_INPUT_HANDLE);
          public static readonly IntPtr StdOut = GetStdHandle(STD_OUTPUT_HANDLE);
          public static readonly IntPtr StdErr = GetStdHandle(STD_ERROR_HANDLE);
        }

        // P/Invoke function imports
        ////////////////////////////////////////////////////////////////////////////
        [DllImport("kernel32.dll", SetLastError=true)]
        public static extern bool CloseHandle(IntPtr hHandle);

        [DllImport("kernel32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern IntPtr CreateFile
          (
          [MarshalAs(UnmanagedType.LPTStr)] string filename,
          uint access,
          uint share,
          IntPtr securityAttributes, // optional SECURITY_ATTRIBUTES struct or IntPtr.Zero
          [MarshalAs(UnmanagedType.U4)] FileMode creationDisposition,
          uint flagsAndAttributes,
          IntPtr templateFile
          );

        [DllImport("kernel32.dll", CharSet=CharSet.Unicode, SetLastError=true)]
        public static extern bool GetCurrentConsoleFontEx
          (
          IntPtr hConsoleOutput,
          bool bMaximumWindow,
          // the [In, Out] decorator is VERY important!
          [In, Out] CONSOLE_FONT_INFOEX lpConsoleCurrentFont
          );

        [DllImport("kernel32.dll", SetLastError=true)]
        public static extern IntPtr GetStdHandle(int nStdHandle);

        [DllImport("kernel32.dll", SetLastError=true)]
        public static extern bool SetCurrentConsoleFontEx
          (
          IntPtr ConsoleOutput,
          bool MaximumWindow,
          // Again, the [In, Out] decorator is VERY important!
          [In, Out] CONSOLE_FONT_INFOEX ConsoleCurrentFontEx
          );


        // Wrapper functions
        ////////////////////////////////////////////////////////////////////////////
        public static IntPtr CreateFile(string fileName, uint fileAccess,
          uint fileShare, FileMode creationDisposition)
        {
          IntPtr hFile = CreateFile(fileName, fileAccess, fileShare, IntPtr.Zero,
            creationDisposition, 0U, IntPtr.Zero);
          if (hFile == INVALID_HANDLE_VALUE)
          {
            throw new Win32Exception();
          }

          return hFile;
        }

        public static CONSOLE_FONT_INFOEX GetCurrentConsoleFontEx()
        {
          IntPtr hFile = IntPtr.Zero;
          try
          {
            hFile = CreateFile("CONOUT$", GENERIC_READ,
            FILE_SHARE_READ | FILE_SHARE_WRITE, FileMode.Open);
            return GetCurrentConsoleFontEx(hFile);
          }
          finally
          {
            CloseHandle(hFile);
          }
        }

        public static void SetCurrentConsoleFontEx(CONSOLE_FONT_INFOEX cfi)
        {
          IntPtr hFile = IntPtr.Zero;
          try
          {
            hFile = CreateFile("CONOUT$", GENERIC_READ | GENERIC_WRITE,
              FILE_SHARE_READ | FILE_SHARE_WRITE, FileMode.Open);
            SetCurrentConsoleFontEx(hFile, false, cfi);
          }
          finally
          {
            CloseHandle(hFile);
          }
        }

        public static CONSOLE_FONT_INFOEX GetCurrentConsoleFontEx
          (
          IntPtr outputHandle
          )
        {
          CONSOLE_FONT_INFOEX cfi = new CONSOLE_FONT_INFOEX();
          if (!GetCurrentConsoleFontEx(outputHandle, false, cfi))
          {
            throw new Win32Exception();
          }

          return cfi;
        }
      }
    }
'@
}

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
    [void] $OSSelection.Items.Add('HCSO Windows 10 v1909')
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

        if ($Selection -eq 'Windows 10 v20H2') {
            $global:WIN10 = 'v20H2'
            $global:WIN10ALT = $Null
        }

        if ($Selection -eq 'HCSO Windows 10 v1909') {
            $global:WIN10ALT = 'v1909'
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

    [void] $OSSelection.Items.Add('Windows 10 v20H2')
    [void] $OSSelection.Items.Add('HCSO Windows 10 v1909')
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

        if ($Selection -eq 'Windows 10 v20H2') {
            $global:WIN10 = 'v20H2'
            $global:WIN10ALT = $Null
        }

        if ($Selection -eq 'HCSO Windows 10 v1909') {
            $global:WIN10ALT = 'v1909'
            $global:WIN10 = $Null
        }
    }
}

function Set-ConsoleFont {
    <#
    .SYNOPSIS
    Allows PowerShell Console Font to be set programatically

    .EXAMPLE
    Set-ConsoleFont

    .INPUTS
    None
    You cannot pipe objects to Set-ConsoleFont.

    .OUTPUTS
    None
    The cmdlet does not return any output.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Consolas', 'Lucida Console')]
        [string] $Name,
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateRange(5,72)]
        [int] $Height
    )

    $cfi = [Windows.Native.Kernel32]::GetCurrentConsoleFontEx()
    $cfi.FontIndex = 0
    $cfi.FontFamily = 0
    $cfi.FaceName = $Name
    $cfi.FontWidth = [int]($Height / 2)
    $cfi.FontHeight = $Height
    [Windows.Native.Kernel32]::SetCurrentConsoleFontEx($cfi)
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

    Set-ConsoleFont -Name 'Lucida Console' -Height '36'

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
If ($global:WIN10 -eq 'v20H2') {
    Write-Host -ForegroundColor Cyan 'Selected v20H2'
    $Global:Command = '
    Start-OSDCloud -OSLanguage en-us -OSBuild 20H2 -OSEdition Enterprise -ZTI'
    Start-Process powershell -ArgumentList "-command invoke-command -scriptblock {$Global:Command}" -Wait
} Elseif ($global:WIN10ALT -eq 'v1909') {
    Write-Host -ForegroundColor Cyan 'Selected v1909'
    $Global:Command = 'Start-OSDCloud -OSLanguage en-us -OSBuild 1909 -OSEdition Enterprise -ZTI'
    Start-Process powershell -ArgumentList "-command invoke-command -scriptblock {$Global:Command}" -Wait
}
#Restart from WinPE
Write-Host -ForegroundColor Cyan 'Restarting in 20 seconds!'
Start-Sleep -Seconds 20
wpeutil reboot

#=============================================================================
#endregion
#=============================================================================
