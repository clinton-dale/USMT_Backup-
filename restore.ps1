# Check for Admin rights.  USMT requires admin to run.  If not run as admin, will fail. /#

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`

    [Security.Principal.WindowsBuiltInRole] "Administrator"))

{
    Write-Warning "You do not have Administrator rights to run this script!`n `n Please re-run this script as an Administrator!"

    Break
}

# Request Restore File location From user /#

$FileName = Read-Host "Please enter the file path that you wish to restore."


Start-Process cmd.exe -ArgumentList "loadstate.exe \\892cdp01\UserData\USMT\$FileName /v:5 /c /ue:$FileName\* /l:\\892cdp01\UserData\USMT\$FileName\LoadState1.log /progress:\\892cdp01\UserData\USMT\$FileName\LoadStateProgress1.log /i:wnb.xml /i:migdocs.xml /i:migapp.xml /i:Printers_Shares.xml /i:Mig_Exclusions.xml /i:Mig_Chrome.xml /i:Mig_Outlook.xml /i:MigBackground.xml /c "

