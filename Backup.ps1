# Check for Admin rights.  USMT requires admin to run.  If not run as admin, will fail. /#

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`

    [Security.Principal.WindowsBuiltInRole] "Administrator"))

{
    Write-Warning "You do not have Administrator rights to run this script!`n `n Please re-run this script as an Administrator!"

    Break
}

# Request Asset tag from User /#

$AssetTag = Read-Host "Please enter the asset tag you wish to backup."

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

Start-Process cmd.exe -ArgumentList "/k c:\backup\ScanState.exe \\892cdp01\UserData\USMT\$AssetTag /ue:*\* /ui:SCP_CORPORATE\$UserName /vsc /v:5 /l:\\892cdp01\UserData\USMT\$AssetTag\ScanState.log /progress:\\892cdp01\UserData\USMT\$AssetTag\ScanStateProgress.log /i:wnb.xml /i:migdocs.xml /i:migapp.xml /i:Printers_Shares.xml /i:Mig_Exclusions.xml /i:Mig_Chrome.xml /i:Mig_Outlook.xml /i:MigBackground.xml /c"


