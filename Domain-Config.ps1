param (
    [switch]$CreateDomain = $false,
    [string]$DomainName = "novatech.local",
    [string]$DomainNetbiosName = "NOVATECH",
    [string]$SafeModeAdminPassword = "MotDePasseAdmin",
    [switch]$JoinToDomain = $false
)

if ($CreateDomain) {
    
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

    
    Install-ADDSForest -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -DomainMode Win2016 -ForestMode Win2016 -SafeModeAdministratorPassword (ConvertTo-SecureString -AsPlainText $SafeModeAdminPassword -Force) -Force

    
    Restart-Computer -Force
}
if ($JoinToDomain) {
    # Join the Windows 10 machine to the domain
    $Credential = Get-Credential
    Add-Computer -DomainName $DomainName -Credential $Credential

    # Restart the Windows 10 machine
    Restart-Computer -Force
}

else {
    Write-Host "Aucune action"
    exit 1
}