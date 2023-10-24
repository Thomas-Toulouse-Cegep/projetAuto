param (
    [string]$GroupName
)

#WallPaper
try
{
    $GPOName = "WallpaperGPO"
    $GPOPath = "CN=Policies,CN=System,DC=novatech,DC=local"

    New-GPO -Name $GPOName | New-GPLink -Target $GPOPath
    Set-GPRegistryValue -Name $GPOName -Key "HKEY_CURRENT_USER\Control Panel\Desktop" -ValueName "Wallpaper" -Value ".\wallpaper.jpg"
}
catch
{
    Write-Host "Error: $_"
}

#UninstallApp
try 
{
    $GPOName = "UninstallAppGPO"
    $GPOPath = "CN=Policies,CN=System,DC=novatech,DC=local"

    New-GPO -Name $GPOName | New-GPLink -Target $GPOPath
    New-GPPackage -Name "UninstallApp" -Path "C:\Program Files\Notepad++\uninstall.exe" | New-GPPackageDeployment -Name "UninstallApp" -GPOName $GPOName -Uninstall
}
catch
{
    Write-Host "Error: $_"
}

#InstallApp
try
{
    $GPOName = "InstallAppGPO"
    $GPOPath = "CN=Policies,CN=System,DC=novatech,DC=local"
    $InstallerPath = ".\npp.8.5.8.Installer.x64.exe"

    New-GPO -Name $GPOName | New-GPLink -Target $GPOPath
    New-GPPackage -Name "InstallApp" -Path $InstallerPath | New-GPPackageDeployment -Name "InstallApp" -GPOName $GPOName -Install
}
catch
{
    Write-Host "Error: $_"
}

#BlockUSB
try
{
    if ($GroupName -eq "Techs")
    {
        throw
    }
    $GPOName = "BlockUSBGPO"
    $GPOPath = "CN=Policies,CN=System,DC=novatech,DC=local"

    New-GPO -Name $GPOName | New-GPLink -Target $GPOPath
    Set-GPRegistryValue -Name $GPOName -Key "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\USBSTOR" -ValueName "Start" -Value "4"
}
catch
{
    Write-Host "Error: $_"
}

#RestrictAccess
try
{
    if ($GroupName -eq "Techs")
    {
        throw
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


