param (
    [string]$version = '18.2',
    [string]$project = 'C:\Projects\ADMIN\Admin'
 )


Write-Host 'Rollback to Snapshot for EAMASTER ...'
$sql = @'
ALTER DATABASE EAMASTER SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE EAMASTER
FROM DATABASE_SNAPSHOT = 'EAMASTER_SNP';
'@
Invoke-Sqlcmd -Query $sql -ServerInstance '.\R14' -Database 'master' -QueryTimeout 0

Write-Host 'Rollback to Snapshot for EASUPPORT ...'
$sql = @'
ALTER DATABASE EASUPPORT SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE EASUPPORT
FROM DATABASE_SNAPSHOT = 'EASUPPORT_SNP';
'@
Invoke-Sqlcmd -Query $sql -ServerInstance '.\R14' -Database 'master' -QueryTimeout 0

Write-Host 'Rollback to Snapshot for AUTHENTICATION ...'
$sql = @'
ALTER DATABASE [AUTHENTICATION] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [AUTHENTICATION]
FROM DATABASE_SNAPSHOT = 'AUTHENTICATION_SNP';
'@
Invoke-Sqlcmd -Query $sql -ServerInstance '.\R14' -Database 'master' -QueryTimeout 0

Write-Host 'Generating and running scripts ... '
$exepath =  "$($project)\SoftDev\ContinuousIntegration\BuildTools\GenerateSqlScript\bin\Debug\GenerateSqlScript.exe"
$dir = "$($project)\SoftDev\SQL\Databases"

$cmd = "$($exepath) dir=$($dir) version=$($version) isReplica=false isEaCopyAuto=false"
Write-Host $cmd
Invoke-Expression $cmd


Get-ChildItem -path $dir -Recurse -Filter "*$($version).sql" | 
foreach($_) {
    if($_.Name.Equals("AUTHENTICATION_$version.sql") -or $_.Name.Equals("EAMASTER_$version.sql") -or $_.Name.Equals("EASUPPORT_$version.sql") ) {        
        Write-Host "Executing: $($_.fullname)"
        Invoke-Sqlcmd -InputFile $_.fullname -ServerInstance '.\R14' -QueryTimeout 0
    }
}


Get-ChildItem -path $dir -Recurse -Filter "*$($version).sql" | 
foreach($_) {
    if($_.Name.Equals("AUTHENTICATION_$version.sql") -or $_.Name.Equals("EAMASTER_$version.sql") -or $_.Name.Equals("EASUPPORT_$version.sql") ) {        
        Write-Host "Executing: $($_.fullname)"
        Invoke-Sqlcmd -InputFile $_.fullname -ServerInstance '.\R14' -QueryTimeout 0
    }
    Remove-Item $_.fullname
}

Write-Host ""
Read-Host -Prompt "Press Enter to exit"