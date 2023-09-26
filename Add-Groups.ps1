param (
    [string]$Name
)
Write-Host($Name)

function Add-Group {
    param (
        [string]$Name
    )
    New-ADGroup -Name $Name -GroupScope Global -GroupCategory Security
}

Add-Group -Name $Name

