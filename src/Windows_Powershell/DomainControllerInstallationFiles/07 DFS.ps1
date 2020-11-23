Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
# Functie om Ini files te parsen
Function Parse-IniFile ($file) {
  $ini = @{}

  switch -regex -file $file {
    "^\[(.+)\]$" {
      $section = $matches[1].Trim()
      $ini[$section] = @{}
    }
    "^\s*([^#].+?)\s*=\s*(.*)" {
      $name,$value = $matches[1..2]
      # skip comments that start with semicolon:
      if (!($name.StartsWith(";"))) {
        $ini[$section][$name] = $value.Trim()
      }
    }
  }
  $ini
}

# Variabele voor het pad van onze Ini file aan te geven
$IniFilePath = "..\Variabelen.ini"
# Parsen van onze Ini file in een variabele
$IniVariabelen = Parse-IniFile $IniFilePath
# Printen van onze gegevens in de Ini file
Write-Host -ForegroundColor Yellow "Inhoud van de Ini file:"
$IniVariabelen

$DriveLetter = $IniVariabelen.ALFA.DriveLetter
$Namespace = $IniVariabelen.ALFA.Namespace
$Rootfolder = $IniVariabelen.ALFA.Rootfolder
$Homefolder = $IniVariabelen.ALFA.Homefolder
$ServerNaam = $IniVariabelen.ALFA.ServerNaam
$DomeinNaam = $IniVariabelen.ALGEMEEN.DomeinNaam

mkdir $DriveLetter":\$Rootfolder\$Namespace"
New-SmbShare -Name $Namespace$ -Path $DriveLetter":\$Rootfolder\$Namespace" -FullAccess Everyone
New-DfsnRoot -TargetPath "\\$ServerNaam\$Namespace$" -Type DomainV2 -Path "\\$DomeinNaam\$Namespace"

mkdir $DriveLetter":\$Namespace\$Homefolder"
New-SmbShare -Name $Homefolder$ -Path $DriveLetter":\$Namespace\$Homefolder" -FullAccess Everyone
New-DfsnFolder -Path "\\$DomeinNaam\$Namespace\$Homefolder" -TargetPath "\\$ServerNaam\$Homefolder$" -EnableTargetFailback $true

$HomeDrive = $DriveLetter + ':'
$UserRoot = "\\" + $DomeinNaam + "\" + $Namespace + "\" + $Homefolder + "\"
$UsersOUPath = $IniVariabelen.ALFA.OUPath + "," + $IniVariabelen.ALFA.DCPath

Get-ADUser -Filter * -SearchBase $UsersOUPath | Foreach-Object {
$sam = $_.SamAccountName
$sid = $_.Sid
$HomeDir=$UserRoot+$sam

# Assign the Drive letter and Home Drive for the user in Active Directory
SET-ADUSER $sam –HomeDrive $HomeDrive –HomeDirectory $HomeDir

# Create the folder on the root of the common Users Share
NEW-ITEM –path $HomeDir -type Directory -force

$account=$Domain+’\’+$Accountname

# Set parameters for Access rule
$rights=[System.Security.AccessControl.FileSystemRights]::FullControl
$inheritance=[System.Security.AccessControl.InheritanceFlags]”ContainerInherit,ObjectInherit”
$propagation=[System.Security.AccessControl.PropagationFlags]::None
$allowdeny=[System.Security.AccessControl.AccessControlType]::Allow
$dirACE=New-Object System.Security.AccessControl.FileSystemAccessRule ($sid,$rights,$inheritance,$propagation,$allowdeny)
$dirACL=Get-Acl $HomeDir

$dirACL.AddAccessRule($dirACE)

Set-Acl -path $HomeDir -AclObject $dirACL

Write-Host $HomeDir access rights assigned

}

# Einde
$Shell = New-Object -ComObject "WScript.Shell"
$Button = $Shell.Popup("Klik op OK om verder te gaan.", 0, "Het script is klaar!", 0)
