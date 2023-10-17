# installer module 
Install-Module -Name ImportExcel -RequiredVersion 7.8.4
# Importez le module ImportExcel
Import-Module ImportExcel


$employes = Import-Excel -Path "C:\Users\Administrateur\Documents\projetAuto\Data.xlsx" -WorksheetName "Data"

# Parcourez chaque ligne du XLSX et créez les utilisateurs
foreach ($employe in $employes) {
    $prenom = $employe.Prenom
    $nom = $employe.Nom
    $samAccountName = $employe.samAccountName
    $motDePasse = $employe."mot de passe"
    $groupe = $employe.Groupe
    Write-Host "Creation de l'utilisateur $prenom $nom ($samAccountName) dans le groupe $groupe"

    
    try {
        # Créez l'utilisateur
        New-ADUser -Name "$prenom $nom" -SamAccountName $samAccountName -UserPrincipalName "$samAccountName@votre-domaine.com" -AccountPassword (ConvertTo-SecureString -AsPlainText $motDePasse -Force) -Enabled $true
    }
    catch {
        Write-Host "Le user "$samAccountName" existe deja"
    }

    try {
    # Créez unjà dossier partagé pour le groupe s'il n'existe pas dé
    $dossierPartage = "C:\Chemin\vers\dossier\$groupe"
    if (-not (Test-Path -Path $dossierPartage -PathType Container)) {
        #New-Item -Path $dossierPartage -ItemType Directory
        C:\Users\Administrateur\Documents\projetAuto\Add-Groups.ps1 $groupe
        try {
            Add-ADGroupMember -Identity $groupe -Members $samAccountName
        }
        catch {
            Write-Host "Le user "$samAccountName" est deja dans le groupe $groupe"
        }
    } 
    } 
    catch {
        Write-Host "echec de la creation du dossier partage $groupe"
    
    }
}

