$dir = 'C:\Projects\ADMIN\Admin\SoftDev'

#$dir = 'C:\Projects\ADMIN\IndividualSubscriberService'
#$dir = 'C:\Projects\AUTHENTICATION\webauth'
#$dir = 'C:\Projects\AUTHENTICATION\OAuthAuthorizationServer'

Get-ChildItem -path $dir -Recurse -Include web.config,app.config,App.config,connections.config | 
ForEach-Object {
    $file = $_.FullName
    Write-Host $_.FullName

    $doc = (Get-Content $file) -as [Xml]

    foreach( $cs in $doc.configuration.connectionStrings.add) {        
        switch ($cs.name)
        {
            "EAMASTER" {$cs.connectionString = 'Server=.\R14;database=EAMASTER;uid=xxx;pwd=xxx;Connection Lifetime=300'}
            "EAREPLICA" {$cs.connectionString = 'Server=.\R14;database=EAMASTER;uid=yyy;pwd=yyy;Connection Lifetime=300'}
            "EASUPPORT" {$cs.connectionString = 'Server=.\R14;database=EASUPPORT;uid=xxx;pwd=xxx;Connection Lifetime=300'}
            "AUTHENTICATION" {$cs.connectionString = 'Server=.\R14;database=AUTHENTICATION;uid=xxx;pwd=xxx;Connection Lifetime=300'}
            "AUTHREPLICA" {$cs.connectionString = 'Server=.\R14;database=AUTHENTICATION;uid=yyy;pwd=yyy;Connection Lifetime=300'}
            "AUTHMASTER" {$cs.connectionString = 'Server=.\R14;database=AUTHENTICATION;uid=xxx;pwd=xxx;Connection Lifetime=300'}
            "UICONFIG" {$cs.connectionString = 'Server=.\R14;database=UICONFIG;uid=xxx;pwd=xxx;Connection Lifetime=300'}            
            "UICONFIGREPLICA" {$cs.connectionString = 'Server=.\R14;database=UICONFIG;uid=yyy;pwd=yyy;Connection Lifetime=300'}            
        }       
    }
    $doc.Save($file)

    foreach( $cs in $doc.connectionStrings.add) {        
        switch ($cs.name)
        {
            "EAMASTER" {$cs.connectionString = 'Server=.\R14;database=EAMASTER;uid=xxx;pwd=xxx;Connection Lifetime=300'}
            "EAREPLICA" {$cs.connectionString = 'Server=.\R14;database=EAMASTER;uid=yyy;pwd=yyy;Connection Lifetime=300'}
            "EASUPPORT" {$cs.connectionString = 'Server=.\R14;database=EASUPPORT;uid=xxx;pwd=xxx;Connection Lifetime=300'}
            "AUTHENTICATION" {$cs.connectionString = 'Server=.\R14;database=AUTHENTICATION;uid=xxx;pwd=xxx;Connection Lifetime=300'}
            "AUTHREPLICA" {$cs.connectionString = 'Server=.\R14;database=AUTHENTICATION;uid=yyy;pwd=yyy;Connection Lifetime=300'}
            "AUTHMASTER" {$cs.connectionString = 'Server=.\R14;database=AUTHENTICATION;uid=xxx;pwd=xxx;Connection Lifetime=300'}
            "UICONFIG" {$cs.connectionString = 'Server=.\R14;database=UICONFIG;uid=xxx;pwd=xxx;Connection Lifetime=300'}            
            "UICONFIGREPLICA" {$cs.connectionString = 'Server=.\R14;database=UICONFIG;uid=yyy;pwd=yyy;Connection Lifetime=300'}            
        }       
    }
    $doc.Save($file)
}


Write-Host ""
Read-Host -Prompt "Press Enter to exit"