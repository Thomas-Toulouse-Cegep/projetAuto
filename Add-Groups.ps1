param (
    [array]$GroupNameList = @("R&D", "Marketing", "Ventes" ,"Techs"
    ))	

Write-Host($Name)

function Add-Group
{
    param (
        [array]$GroupNameList
    )
    $GroupNameList=@("R&D", "Marketing", "Ventes" ,"Techs")
    foreach ($name in $GroupNameList)
    {
        Write-Host "Création du groupe $name"
        if (Get-ADGroup -Filter {Name -ne $name})
        {
            New-ADGroup -Name $name -GroupScope Global -GroupCategory Security
        }
    }
}

Add-Group -Name $GroupNameList

