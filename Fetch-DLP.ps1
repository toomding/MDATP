function ShowDlpPolicy($Path)
{
    $policyName = 'dlpPolicy'
    $Location = "$Path\DLP"
    New-Item -ItemType Directory -Path $Location | Out-Null
    $byteArray = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection' -Name $policyName
    $memoryStream = New-Object System.IO.MemoryStream(,$byteArray)
    $deflateStream = New-Object System.IO.Compression.DeflateStream($memoryStream,  [System.IO.Compression.CompressionMode]::Decompress)
    $streamReader =  New-Object System.IO.StreamReader($deflateStream, [System.Text.Encoding]::Unicode)
    $policyStr = $streamReader.ReadToEnd()
    $policy = $policyStr | ConvertFrom-Json
    $policyBodyCmd = ($policy.body | ConvertFrom-Json).cmd
    $policyBodyCmd | Format-List -Property hash,type,cmdtype,id,priority,timestamp,enforce | Out-File "$Location\$policyName.txt"
    $timestamp = [datetime]$policyBodyCmd.timestamp
    "Timestamp: $($timestamp.ToString('u'))" | Out-File "$Location\$policyName.txt" -Append
 
    # convert from/to json so it's JSON-formatted
    $params = $policyBodyCmd.paramsstr | ConvertFrom-Json
    $params | ConvertTo-Json -Depth 20 > "$Location\$policyName.json"
}
ShowDlpPolicy .\