param (
    [switch]$CreateDomain = $false,
    [string]$DomainName = "novatech.local",
    [string]$DomainNetbiosName = "NOVATECH",
    [string]$SafeModeAdminPassword = "Test1234",
    [switch]$JoinToDomain = $false,
    [switch]$ConfigureClient = $false,
    [string]$DnsServer = "127.0.0.1",
    [string]$DnsServerAux = "8.8.8.8",
    [string]$ComputerName = "WIN10",
    [switch]$Help = $false

)

if ($CreateDomain) {
    
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

    Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -DomainMode WinThreshold -ForestMode WinThreshold -InstallDns -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText $SafeModeAdminPassword -Force) -Force
    
    Restart-Computer -Force
}
if ($JoinToDomain) {
    # Join the Windows 10 machine to the domain
    $Credential = Get-Credential
    Add-Computer -DomainName $DomainName -Credential $Credential

   
    Restart-Computer -Force
}

if ($ConfigureClient) {
    # Configure le client pour utiliser le DNS du serveur

    $InterfaceIndex = (Get-NetAdapter).InterfaceIndex
    Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ($DnsServer,$DnsServerAux)
    
    # join domain
    $Credential = Get-Credential
    Add-Computer -DomainName $DomainName -Credential $Credential
    Restart-Computer -Force

}

if ($Help){
    Write-Host "CreateDomain : Create a new domain"
    Write-Host "DomainName : Name of the domain"
    Write-Host "DomainNetbiosName : Netbios name of the domain"
    Write-Host "SafeModeAdminPassword : Password of the domain"
    Write-Host "JoinToDomain : Join the computer to the domain"
    Write-Host "ConfigureClient : Configure the client"
    Write-Host "DnsServer : DNS server"
    Write-Host "ComputerName : Name of the computer"
    Write-Host "Help : Display help"
}

else {
    Write-Host "Aucune action"
    exit 1
}