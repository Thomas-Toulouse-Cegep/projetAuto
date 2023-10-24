param (
    [string]$GroupName
)

function Add-Group
{
    param (
        [string]$GroupName
    )

        if (Get-ADGroup -Filter {Name -ne $GroupName})
        {
            try{
                New-ADGroup -Name $GroupName -GroupScope Global -GroupCategory Security
                Write-Host "Creation du groupe $GroupName"
            }
            catch {
                Write-Host "Le groupe $GroupName existe deja"
            }
        }
}

Add-Group -GroupName $GroupName



