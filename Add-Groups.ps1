param (
    [array]$GroupNameList
)

Write-Host($Name)

function Add-Group
{
    param (
        [array]$GroupNameList
    )

    foreach ($name in $GroupNameList)
    {
        
        Write-Host "entrer dans le foreach dajout de groupe et le nom du groupe est $name"
        if (not (Get-ADGroup -Filter {Name -eq $name}))
        {
            try{
                New-ADGroup -Name $name -GroupScope Global -GroupCategory Security
                Write-Host "Creation du groupe $name"
            }
            catch {
                Write-Host "Le groupe $name existe deja"
            }
        }
    }
}

Add-Group - $GroupNameList



