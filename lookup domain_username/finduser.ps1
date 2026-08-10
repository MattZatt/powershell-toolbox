$ErrorActionPreferenceSilentlyContinue
$fuser = Read-Host "what is the username we are looking for?" 
$hunted = @(Get-CimInstance Win32_UserProfile | Where-Object {$_.LocalPath -like '*' + $fuser + '*'} | Select-Object *)
foreach ($hunted in $hunted) {
try {
$dehunted = New-Object System.Security.Principal.SecurityIdentifier($hunted.SID)
Write-Host $dehunted.Translate([System.Security.Principal.NTAccount])
}
catch{
$hunted.Sid
}
}