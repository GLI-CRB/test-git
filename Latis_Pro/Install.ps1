#*===============================================
#* 					VARIABLES 
#*===============================================

#Chemin & Numéro de série :
$InstallPath = "$PSScriptRoot\I-Latis-5.5.14.2.exe"
$SerialLTP = "LTP-XXX-XXX-XXX"
#Argument :
$Argument = "/VERYSILENT /SERIALLTP=$SerialLTP /COMPONENTS=LatisPro"
#Nom & Version :
$InstallVersion = "Latis-Pro 5.5.14.2"
#Variable de désinstallation :
$Uninstall = "Latis version 5.5.14.2"

#*===============================================
#* 				DESINSTALLATION 
#*===============================================

#Lance le script de désinstallation avec la variable $Uninstall qui doit correspondre a nom de l'application dans le registe. 
#Utiliser le script "Check_Uninstall.ps1" pour connaitre celle ci
#$UninstallPath = Split-Path -Path $PSScriptRoot
#powershell.exe -nologo -executionpolicy bypass -WindowStyle hidden -noprofile -file "$PSScriptRoot\uninstallScript.ps1" $Uninstall

#*===============================================
#* 				INSTALLATION 
#*===============================================

Write-Host "install $InstallVersion"
Start-Process -FilePath $InstallPath -ArgumentList $Argument  -Wait

#Copie du raccourci "Latis-Pro.lnk" dans le répertoire "Physique-Chimie" :
Move-Item "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Eurosmart\Latis-Pro\Latis-Pro.lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Physique-Chimie\" -Force

#*===============================================
#* 			CONFIGURATION SUPPLEMENTAIRE
#*===============================================

#Installation driver & certificat :
Copy-Item -Path "$PSScriptRoot\Sysam-SP5\*" -Destination "C:\Windows\INF"
Get-ChildItem -Path "C:\Windows\INF\TrustedPublisher_SysamV5.cer" | Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher\
Get-ChildItem "$PSScriptRoot\Sysam-SP5\" -Recurse -Filter "*.inf" | ForEach-Object { pnputil.exe /add-driver $_.FullName /install }

