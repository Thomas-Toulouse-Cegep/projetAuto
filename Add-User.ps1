# installer module 
Install-Module -Name ImportExcel -RequiredVersion 7.8.4
# Importez le module ImportExcel
Import-Module ImportExcel


$employes = Import-Excel -Path "c:\Users\thoma\Bureau\projetAuto\projetAuto\Data.xlsx" -WorksheetName "Data"

# Parcourez chaque ligne du XLSX et créez les utilisateurs
foreach ($employe in $employes) {
    $prenom = $employe.Prenom
    $nom = $employe.Nom
    $samAccountName = $employe.samAccountName
    $motDePasse = $employe."mot de passe"
    $groupe = $employe.Groupe
    Write-Host "Création de l'utilisateur $prenom $nom ($samAccountName) dans le groupe $groupe"

    # Créez l'utilisateur
    #New-ADUser -Name "$prenom $nom" -SamAccountName $samAccountName -UserPrincipalName "$samAccountName@votre-domaine.com" -AccountPassword (ConvertTo-SecureString -AsPlainText $motDePasse -Force) -Enabled $true

    # Ajoutez l'utilisateur au groupe correspondant
    #Add-ADGroupMember -Identity $groupe -Members $samAccountName

    # Créez un dossier partagé pour le groupe s'il n'existe pas déjà
    #$dossierPartage = "C:\Chemin\vers\dossier\$groupe"
  #  if (-not (Test-Path -Path $dossierPartage -PathType Container)) {
      #  New-Item -Path $dossierPartage -ItemType Directory
        # Définissez les autorisations du dossier partagé ici
  #  }

   
}
