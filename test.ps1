$config = Get-Content './config.json' | Out-String | ConvertFrom-Json 
$oldUrl = $config.urls.old
$newUrl = $config.urls.new

foreach($link in $config.links)
{
    $name = $link.name
    $pathAndQuery = $link.pathAndQuery
    md -Force $name

    $oldResponseFileName = $name+'-old.json'
    echo "OLD RESPONSE FILE NAME:$oldResponseFileName"

    $oldUrlAndPath = $oldUrl+$pathAndQuery
    echo "OLD URL:$oldUrlAndPath"

    echo "OLD:MAKING REQUEST"
    Invoke-WebRequest -Uri $oldUrlAndPath | Select-Object -Expand Content | Out-File -FilePath "./$name/$oldResponseFileName" -Encoding Default
    
    $newResponseFileName = $name+'-new.json'
    echo "NEW RESPONSE FILE NAME:$newResponseFileName"

    $newUrlAndPath = $newUrl+$pathAndQuery
    echo "NEW URL:$newUrlAndPath"

    echo "NEW:MAKING REQUEST"
    Invoke-WebRequest -Uri $newUrlAndPath | Select-Object -Expand Content | Out-File -FilePath "./$name/$newResponseFileName" -Encoding Default
    
    $outputFileName = $name+'.txt'
    echo "OUTPUT FILE NAME:$outputFileName"
    json-diff --raw-json "./$name/$oldResponseFileName" "./$name/$newResponseFileName"  | Out-File -FilePath "./$name/$outputFileName"
}
