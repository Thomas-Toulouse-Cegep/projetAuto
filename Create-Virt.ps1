param (
    [string]$vmName="WindowsServer2019" ,
    [string]$vmPath="C:\$USER\Public\VirtualBox VMs" ,
    [string]$isoPath="C:\Users\Public\VirtualBox VMs\WindowsServer2019\WindowsServer2019.iso",
    [int]$vmRam = 2048, # 2 Go
    [int]$vmDisk = 51200 # 50 Go
)



$env:PATH = $env:PATH + ";C:\Program Files\Oracle\VirtualBox"
Write-Host "[Recommande] voulez-vous telecharger l'iso du server automatiser? (y/n)"
if (Read-Host -eq "y") {
    wget 
    <# Action to perform if the condition is true #>
}
if (Test-Path "$vmPath\$vmName") {
    Write-Host "La VM existe deja voulez-vous la supprimer? (y/n)"
    $answer = Read-Host
    if ($answer -eq "y") {
        Write-Host "VM supprimee"
        Write-Host "C:\Users\$Env:UserName\VirtualBox VMs\$vmName"
        VBoxManage unregistervm $vmName --delete        
    }
    else {
        exit 1
    }
}

VBoxManage createvm --name $vmName --ostype "Windows2019_64" --register 
VBoxManage modifyvm $vmName --memory=$vmRam
Write-Host "$vmPath\$vmName\$vmName.vdi"

if (Test-Path  "$vmPath\$vmName\$vmName.vdi") {

    Write-Host "Le Disque existe deja voulez-vous le supprimer? (y/n)"
    $answer = Read-Host
    if ($answer -eq "y") {
        Write-Host "Disque supprime"
        Remove-Item  "$vmPath\$vmName\$vmName.vdi"
    
    }
    else {
        exit 1
    }
}

VBoxManage createhd --filename "$vmPath\$vmName\$vmName.vdi" --size $vmDisk  

VBoxManage storagectl $vmName --name "SATA Controller" --add sata --controller IntelAHCI
VBoxManage storageattach $vmName --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$vmPath\$vmName\$vmName.vdi"

VBoxManage storagectl $vmName --name "IDE Controller" --add ide
VBoxManage storageattach $vmName --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$isoPath"

VBoxManage modifyvm $vmName --vrde on
VBoxManage modifyvm $vmName --vrdemulticon on --vrdeport 3389
VBoxManage modifyvm $vmName --vrdeproperty "Security/Method=RDP"

$answer = Read-Host "Voulez-vous demarrer la VM? (y/n)"
if($answer -eq "n") {
    exit 1
}
else {
    Write-Host "Demarrage de la VM"
    VBoxManage startvm $vmName
}


