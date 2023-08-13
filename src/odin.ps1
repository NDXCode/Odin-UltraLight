Add-Type -AssemblyName System.Windows.Forms



Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class ConsoleWindow {
        [DllImport("kernel32.dll", ExactSpelling = true)]
        public static extern IntPtr GetConsoleWindow();

        [DllImport("user32.dll")]
        public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);

        public static void SetWindowSize(int width, int height) {
            IntPtr handle = GetConsoleWindow();
            SetWindowPos(handle, IntPtr.Zero, 0, 0, width, height, 0x0002 | 0x0004);
        }
    }
"@

# Set the console window size
[ConsoleWindow]::SetWindowSize(400, 320)





$form = New-Object System.Windows.Forms.Form
$form.Text = "Odin UltraLight"
$form.Size = New-Object System.Drawing.Size(400, 320)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
# Function to open file dialog and store selected path
function Select-File {
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    #$dialog.InitialDirectory = $PWD.Path
    $dialog.Filter = "Software Files (*.tar, *.img, *.txt, *.xml, *.md5)|*.tar;*.img;*.txt;*.xml;*.md5"
    if ($dialog.ShowDialog() -eq 'OK') {
        return $dialog.FileName
    }
    return $null
}
Write-Host -----------------
Write-Host $t Odin UltraLight
Write-Host  $t Made by NDXCode
Write-Host -----------------

# Function to update label with selected path
function Update-Label {
    param (
        [System.Windows.Forms.Label]$label,
        [string]$path
    )
    $label.Text = $path
}

# Function to clear all paths
function Clear-Paths {
    $blLabel.Text = ""
    $apLabel.Text = ""
    $cpLabel.Text = ""
    $cscLabel.Text = ""
    $umsLabel.Text = ""
}

function Flash-ROM {
$odin_path = 'odin.exe'
$bl_path = ""
$ap_path = ""
$cp_path = ""
$csc_path = ""
$ums_path = ""
$ignore_MD5 = "--ignore-md5"

if ($blLabel.Text -ne "") {
    $bl_path = "-b " + "'" + $blLabel.Text + "'"
}

if ($apLabel.Text -ne "") {
    $ap_path = "-a " + "'" + $apLabel.Text + "'"
}

if ($cpLabel.Text -ne "") {
    $cp_path = "-c " + "'" + $cpLabel.Text + "'"
}

if ($cscLabel.Text -ne "") {
    $csc_path = "-s " + "'" + $cscLabel.Text + "'"
}

if ($umsLabel.Text -ne "") {
    $ums_path = "-u " + "'" + $umsLabel.Text + "'"
}

# Prompt the user to confirm that the device is in download mode
$confirmation = [System.Windows.Forms.MessageBox]::Show("Please confirm that the device is in download mode.", "Download Mode", [System.Windows.Forms.MessageBoxButtons]::OKCancel, [System.Windows.Forms.MessageBoxIcon]::Information)

# Check if the user confirmed that the device is in download mode
if ($confirmation -eq [System.Windows.Forms.DialogResult]::OK) {
    # Flash the recovery image using Odin
    Write-Host "Trying to flash image..."
    # Write-Host "$odin_path $bl_path $ap_path $cp_path $csc_path $ums_path"

    Start-Process -FilePath $odin_path -ArgumentList " $ignore_MD5 $bl_path $ap_path $cp_path $csc_path $ums_path" -NoNewWindow -Wait

    Write-Host "Done!"
}
else {
    Write-Host "User cancelled flashing."
}

}
# Create labels to display file paths
$blLabel = New-Object System.Windows.Forms.Label
$blLabel.Text = ""
$blLabel.AutoSize = $true
$blLabel.Location = New-Object System.Drawing.Point(120, 23)
$form.Controls.Add($blLabel)

$apLabel = New-Object System.Windows.Forms.Label
$apLabel.Text = ""
$apLabel.AutoSize = $true
$apLabel.Location = New-Object System.Drawing.Point(120, 63)
$form.Controls.Add($apLabel)

$cpLabel = New-Object System.Windows.Forms.Label
$cpLabel.Text = ""
$cpLabel.AutoSize = $true
$cpLabel.Location = New-Object System.Drawing.Point(120, 103)
$form.Controls.Add($cpLabel)

$cscLabel = New-Object System.Windows.Forms.Label
$cscLabel.Text = ""
$cscLabel.AutoSize = $true
$cscLabel.Location = New-Object System.Drawing.Point(120, 143)
$form.Controls.Add($cscLabel)

$umsLabel = New-Object System.Windows.Forms.Label
$umsLabel.Text = ""
$umsLabel.AutoSize = $true
$umsLabel.Location = New-Object System.Drawing.Point(120, 183)
$form.Controls.Add($umsLabel)

$authorLabel = New-Object System.Windows.Forms.Label
$authorLabel.Text = "Made by NDXCode"
$authorLabel.AutoSize = $true
$authorLabel.Location = New-Object System.Drawing.Point(0, 0)
$form.Controls.Add($authorLabel)

# Create buttons for file selection
$blButton = New-Object System.Windows.Forms.Button
$blButton.Text = "BL"
$blButton.Location = New-Object System.Drawing.Point(30, 20)
$blButton.Add_Click({Update-Label -label $blLabel -path (Select-File)})
$form.Controls.Add($blButton)

$apButton = New-Object System.Windows.Forms.Button
$apButton.Text = "AP"
$apButton.Location = New-Object System.Drawing.Point(30, 60)
$apButton.Add_Click({Update-Label -label $apLabel -path (Select-File)})
$form.Controls.Add($apButton)

$cpButton = New-Object System.Windows.Forms.Button
$cpButton.Text = "CP"
$cpButton.Location = New-Object System.Drawing.Point(30, 100)
$cpButton.Add_Click({Update-Label -label $cpLabel -path (Select-File)})
$form.Controls.Add($cpButton)

$cscButton = New-Object System.Windows.Forms.Button
$cscButton.Text = "CSC"
$cscButton.Location = New-Object System.Drawing.Point(30, 140)
$cscButton.Add_Click({Update-Label -label $cscLabel -path (Select-File)})
$form.Controls.Add($cscButton)

$umsButton = New-Object System.Windows.Forms.Button
$umsButton.Text = "UMS"
$umsButton.Location = New-Object System.Drawing.Point(30, 180)
$umsButton.Add_Click({Update-Label -label $umsLabel -path (Select-File)})
$form.Controls.Add($umsButton)

$clearButton = New-Object System.Windows.Forms.Button
$clearButton.Text = "Reset Files"
$clearButton.Location = New-Object System.Drawing.Point(30, 220)
$clearButton.Width = 340
$clearButton.Add_Click({Clear-Paths})
$form.Controls.Add($clearButton)

$flashButton = New-Object System.Windows.Forms.Button
$flashButton.Text = "Flash"
$flashButton.Location = New-Object System.Drawing.Point(30, 260)
$flashButton.Width = 340
$flashButton.Add_Click({Flash-ROM})
$form.Controls.Add($flashButton)

$null = $form.ShowDialog()
