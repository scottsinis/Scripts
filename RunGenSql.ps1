param (
    [string]$isReplica = 'Yes',
    [string]$version = '18.2',
    [string]$project = 'C:\Projects\ADMIN\Admin'
 )

$exepath =  "$($project)\SoftDev\ContinuousIntegration\BuildTools\GenerateSqlScript\bin\Debug\GenerateSqlScript.exe"
$dir = "$($project)\SoftDev\SQL\Databases"

$cmd = "$($exepath) dir=$($dir) version=$($version) isReplica=false isEaCopyAuto=false"
Write-Host $cmd
Invoke-Expression $cmd
if($isReplica -ne 'No') {
    $cmd = "$($exepath) dir=$($dir) version=$($version) isReplica=true isEaCopyAuto=false"
    Write-Host $cmd
    Invoke-Expression $cmd
}

Get-ChildItem -path $dir -Recurse -Filter "*$($version).sql" | 
foreach($_) {
    Write-Host $_.fullname
    Get-Content $_.fullname
    #Remove-Item $_.fullname
}

