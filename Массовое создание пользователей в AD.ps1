Import-Module ActiveDirectory
#Назначение переменной $Domain, например local.ru
$Domain="@domain_name"
#Назначение переменной $UserOu, путь до OU, в котором будут созданы пользователи 
$UserOu="OU_Path"
#Назначение переменной $NewUsersList, и путь к файлу с пользователями, используется разделитель ";"
$NewUsersList=Import-Csv -Delimiter (";") -Path Путь к файлу пользователи.csv

ForEach ($User in $NewUsersList) {

$FullName=$User.FullName

$givenName=$User.givenName

$sAMAccountName=$User.SamAccountName

$sn=$User.sn

$userPrincipalName=$User.SamAccountName+$Domain

$AccountPassword=$User.AccountPassword

$expire=$null

New-ADUser -PassThru -Path $UserOu -Enabled $True -ChangePasswordAtLogon $false -AccountPassword (ConvertTo-SecureString  -AsPlainText $AccountPassword -Force) -CannotChangePassword $True -DisplayName $FullName -GivenName $givenName -Name $FullName -SamAccountName $sAMAccountName -Surname $sn -UserPrincipalName $userPrincipalName
Get-ADUser -Filter * -SearchBase "$UserOu" | Set-ADUser -PasswordNeverExpires:$True
}