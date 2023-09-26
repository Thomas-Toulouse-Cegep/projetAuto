param (
    [array]$GroupNameList 
)
Write-Host($Name)

function Add-Group {
    param (
        [array]$GroupNameList = {"R&D", "Marketing", "Ventes" ," Techs"}
    )

    foreach ($name in $GroupNameList)
    {
        if (Get-ADGroup -Filter {Name -neq $name})
        {
            New-ADGroup -Name $name -GroupScope Global -GroupCategory Security
        }
    }
}

Add-Group -Name $GroupNameList

