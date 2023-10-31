
    # installer module 
    Install-Module -Name ImportExcel -RequiredVersion 7.8.4
    # Importez le module ImportExcel
    Import-Module ImportExcel


    $employes = Import-Excel -Path "C:\Users\Administrateur\Documents\projetAuto\Data.xlsx" -WorksheetName "Data"

    # Parcourez chaque ligne du XLSX et créez les utilisateurs
    foreach ($employe in $employes) 
    {
        $prenom = $employe.Prenom
        $nom = $employe.Nom
        $samAccountName = $employe.samAccountName
        $motDePasse = $employe."mot de passe"
        $groupe = $employe.Groupe
        Write-Host `n
        # Créez l'utilisateur
        try 
        {
            $user = Get-ADUser -Filter {SamAccountName -eq $samAccountName}

            if ($user -ne $null) {
                Remove-ADUser $user -Confirm:$false
                Write-Host "Le user $samAccountName a ete supprime car il existait deja."
            }

            New-ADUser -Name "$prenom $nom" -SamAccountName $samAccountName -UserPrincipalName "$samAccountName@votre-domaine.com" -AccountPassword (ConvertTo-SecureString -AsPlainText $motDePasse -Force) -Enabled $true
            Write-Host("Le user $samAccountName ")
        }
        catch {
            Write-Host "Erreur lors de la creation du nouvel utilisateur."
        }


        #créé le groupe
        try {
            C:\Users\Administrateur\Documents\projetAuto\Add-Groups.ps1 -GroupName $groupe
        }
        catch {
            Write-Host "Path invalide ou impossible d'acceder au fichier Add-Groups.ps1"
        }
        #ajouter l'utilisateur au groupe
        try {
            Add-ADGroupMember -Identity $groupe -Members $samAccountName
        }
        catch {
            Write-Host "L utilisateur $samAccountName est deja dans le groupe $groupe"
        }

        # Créez un dossier partagé pour le groupe s'il n'existe pas deja
        try 
        {
            $dossierPartage = "C:\Users\Administrateur\Documents\test"
            if ((Test-Path -Path $dossierPartage -PathType Container)) {
                if (-not (Test-Path -Path "$dossierPartage\$groupe" -PathType Container))
                {
                    New-Item -Path $dossierPartage -ItemType Directory -Name $groupe
                    New-SmbShare -Name $groupe -Path "$dossierPartage\$groupe" -FullAccess "novatech\$groupe"
                }
                else {
                    Write-Host "Le groupe partager $groupe existe deja"
                }    
            } 
        } 
        catch {
            Write-Host "Echec de la creation du dossier partage $groupe"
        }
        
        #gpo
        try {
            C:\Users\Administrateur\Documents\projetAuto\GPO.ps1 -GroupName $groupe
        }
        catch {
            Write-Host "Echec de l'utilisation du GPO."
        }
    }