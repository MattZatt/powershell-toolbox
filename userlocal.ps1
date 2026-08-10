[string]$username = Read-Host -Prompt "Enter Username" 
$Password = Read-Host -AsSecureString
$params = @{
    Name        = $username
    Password    = $Password
    FullName    = $username
    Description = 'Office Name'
}
New-LocalUser @params -PasswordNeverExpires
Add-LocalGroupMember -Group Users -Member $username
