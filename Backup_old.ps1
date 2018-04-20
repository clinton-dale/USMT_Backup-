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


$users = (get-childitem C:\Users).Name
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

$USMT = %~dp0scanstate.exe \\892cdp01\UserData\USMT\$AssetTag_$UserName /ue:*\* /ui:SCP_CORPORATE\$UserName /v:5 /l:\\892cdp01\UserData\USMT\$AssetTag\ScanState.log /progress:\\892cdp01\UserData\USMT\$AssetTag\ScanStateProgress.log /i:%~dp0wnb.xml /i:%~dp0migdocs.xml /i:%~dp0migapp.xml /i:%~dp0Printers_Shares.xml /i:%~dp0Mig_Exclusions.xml /i:%~dp0Mig_Chrome.xml /i:%~dp0Mig_Outlook /i:%~dp0Mig_Background.xml /c

Invoke-Expression $USMT