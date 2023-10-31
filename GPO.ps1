Import-GPO
param (
    [string]$GroupName
)

#WallPaper
try
{
    #check if gpo already exist
    $GPO = Get-GPO -Name "WallpaperGPO"
    if ($null -ne $GPO)
    {
        throw "Le GPO existe deja ou le gpo de l'image a echoue"
    }
    $GPOName = "WallpaperGPO"
    $GPOPath = "CN=Policies,CN=System,DC=novatech,DC=local"

    New-GPO -Name $GPOName | New-GPLink -Target $GPOPath
    Set-GPRegistryValue -Name $GPOName -Key "HKEY_CURRENT_USER\Control Panel\Desktop" -ValueName "Wallpaper" -Value ".\wallpaper.jpg"
}
catch
{
    Write-Host "Erreur: $_"
}

#UninstallApp
try 
{
    #check if gpo already exist
    $GPO = Get-GPO -Name "UninstallAppGPO"
    if ($null -ne $GPO)
    {
        throw "Le GPO existe deja ou le gpo de supression de l'application a echoue"
    }
    $GPOName = "UninstallAppGPO"
    $GPOPath = "CN=Policies,CN=System,DC=novatech,DC=local"

    New-GPO -Name $GPOName | New-GPLink -Target $GPOPath
    New-GPPackage -Name "UninstallApp" -Path "C:\Program Files\Notepad++\uninstall.exe" | New-GPPackageDeployment -Name "UninstallApp" -GPOName $GPOName -Uninstall
}
catch
{
    Write-Host "Erreur: $_"
}

#InstallApp
try
{
    #check if gpo already exist
    $GPO = Get-GPO -Name "InstallAppGPO"
    if ($null -ne $GPO)
    {
        throw "Le GPO existe deja"
    }
    $GPOName = "InstallAppGPO"
    $GPOPath = "CN=Policies,CN=System,DC=novatech,DC=local"
    $InstallerPath = ".\npp.8.5.8.Installer.x64.exe"

    New-GPO -Name $GPOName | New-GPLink -Target $GPOPath
    New-GPPackage -Name "InstallApp" -Path $InstallerPath | New-GPPackageDeployment -Name "InstallApp" -GPOName $GPOName -Install
}
catch
{
    Write-Host "Erreur: $_"
}

#BlockUSB
try
{
    if ($GroupName -eq "Techs")
    {
        throw
    }

    #check if gpo already exist
    $GPO = Get-GPO -Name "BlockUSBGPO"
    if ($null -ne $GPO)
    {
        throw "Le GPO existe deja ou le gpo de bloquage usb a echoue"
    }
    $GPOName = "BlockUSBGPO"
    $GPOPath = "CN=Policies,CN=System,DC=novatech,DC=local"

    New-GPO -Name $GPOName | New-GPLink -Target $GPOPath
    Set-GPRegistryValue -Name $GPOName -Key "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" -ValueName "Start" -Value "4"
}
catch
{
    Write-Host "Erreur: $_"
}

#RestrictAccess
try
{
    if ($GroupName -eq "Techs")
    {
        throw
    }

    #check if gpo already exist
    $GPO = Get-GPO -Name "RestrictAccessGPO"
    if ($null -ne $GPO)
    {
        throw "Le GPO existe deja ou le gpo de restriction d'acces a echoue"
    }
    $GPOName = "RestrictAccessGPO"
    $GPOPath = "CN=Policies,CN=System,DC=novatech,DC=local"

    New-GPO -Name $GPOName | New-GPLink -Target $GPOPath
    Set-GPRegistryValue -Name $GPOName -Key "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -ValueName "NoControlPanel" -Value "1"
    Set-GPRegistryValue -Name $GPOName -Key "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System" -ValueName "NoRun" -Value "1"
}
catch
{
    Write-Host "Error: $_"
}


