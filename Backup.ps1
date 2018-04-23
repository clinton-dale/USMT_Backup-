# Check for Admin rights.  USMT requires admin to run.  If not run as admin, will fail. /#

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`

    [Security.Principal.WindowsBuiltInRole] "Administrator"))

{
    Write-Warning "You do not have Administrator rights to run this script!`n `n Please re-run this script as an Administrator!"
	Pause
    Break
}

#Get the complete drive path of the current working directory.  This will be needed later to run the scanstate command /#

$DrivePath = (Get-Item -Path ".\").FullName

# Request Asset tag from User /#

$AssetTag = Read-Host "Please enter the asset tag you wish to backup."

# Request backup locaiton from user. /#

$Location = Read-Host "Please enter the Full Drive path of the location that you want to store the migration file."

# use the entered Asset tag to scan for profiles in the c:\users directory /#

$users = (get-childitem \\$AssetTag\C$\Users).Name
$important = @()

# popup that lists the found usernames /#

foreach($user in $users){
    if ($user -ne 'ITADMIN' -and $user -ne 'Administrator' -and $user -ne 'Default' -and $user -ne 'Public' -and $user -ne 'defaultuser0') { 
        $important +=$user
        }
    }
if ($important.count -gt 0){ 
    ("The following profiles have been detected! `n`t$important `n")
}

# Prompt for the Username /#
$UserName = Read-Host "Please enter the username that you want to backup"

#/ Begin backup using USMT Scanstate.exe /#

Start-Process cmd.exe -ArgumentList "/k $DrivePath\ScanState.exe $Location\$AssetTag /config:$DrivePath\Config_Win10.xml /ue:* /ui:SCP_CORPORATE\$UserName /vsc /v:5 /l:$Location\$AssetTag\ScanState.log /progress:$Location\$AssetTag\ScanStateProgress.log /i:wnb.xml /i:migdocs.xml /i:migapp.xml /i:Printers_Shares.xml /i:Mig_Exclusions.xml /i:Mig_Chrome.xml /i:Mig_Outlook.xml /i:MigBackground.xml /c"
# /k - Keep the CMD window open until user closes the window.  /c - Continue.  The USMT program will continue on non-fatal errors.  Access denied is a non-fatal error /# 

