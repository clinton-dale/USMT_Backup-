    # convert the task sequence variables to powershell variables

$tsenv = New-Object -COMObject Microsoft.SMS.TSEnvironment
$OSDStore = $tsenv.Value("OSDStateStorePath")
$CompName = $tsenv.Value("OSDComputerName")
$SMSTSData = $tsenv.Value("_SMSTSMDataPath")

    # gets all drive letters that winpe assigned

$DriveLetters = gwmi win32_volume | select-object -expand driveletter
$Drives = New-Object System.Collections.ArrayList

    # go through each drive letter and remove drive letters that aren't what i want

ForEach ($DriveLetter in $DriveLetters){

$Label = gwmi win32_volume | Where {$_.DriveLetter -Match "$DriveLetter"} | select-object -expand label
$DriveType = gwmi win32_volume | Where {$_.DriveLetter -Match "$DriveLetter"} | select-object -expand drivetype
If($Label -ne "System Reserved" -and $Label -ne "System" -and $Label -ne "Recovery" -and $Label -ne "Boot" -and $DriveType -eq "3"){$Drives.Add("$DriveLetter")}

}

    # go through the drives i want and find the one with the windows directory, assign that letter for the scanstate executable

ForEach ($Drive in $Drives){

If (Test-Path $Drive\Windows) {$OSDrive = $Drive}

}

    # run scanstate on the drive with the windows directory

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $Scriptpath

$exe = "$dir\scanstate.exe"
$param = "$OSDStore /o /localonly /v:5 /c /ue:$CompName\* /offlineWinDir:$OSDrive\WINDOWS /l:$OSDStore\ScanState.log /progress:$OSDStore\ScanStateProgress.log /i:$SMSTSData\Packages\DCM00175\wnb.xml /i:$SMSTSData\Packages\DCM00175\migdocs.xml /i:$SMSTSData\Packages\DCM00175\migapp.xml /i:$SMSTSData\Packages\DCM00175\printers.xml /i:$SMSTSData\Packages\DCM00175\Mig_Outlook.xml /i:$SMSTSData\Packages\DCM00175\Printers_Shares.xml"

start-process -filepath "$exe" -argumentlist "$param" -nonewwindow -wait