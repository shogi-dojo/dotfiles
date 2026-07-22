param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string] $FilePath
)

$ErrorActionPreference = 'Stop'

$emacsBin = Join-Path $env:USERPROFILE 'scoop\apps\emacs\current\bin'
$client = Join-Path $emacsBin 'emacsclient.exe'
$runemacs = Join-Path $emacsBin 'runemacs.exe'
$serverName = 'server'

function Test-EmacsServer {
    & $client --no-wait --server-file $serverName --eval 't' 2>$null | Out-Null
    return $LASTEXITCODE -eq 0
}

if (-not (Test-EmacsServer)) {
    Start-Process -FilePath $runemacs | Out-Null
    $ready = $false
    for ($attempt = 0; $attempt -lt 80; $attempt++) {
        Start-Sleep -Milliseconds 250
        if (Test-EmacsServer) {
            $ready = $true
            break
        }
    }
    if (-not $ready) {
        throw 'Emacs started, but its server did not become ready.'
    }
}

$fullPath = [IO.Path]::GetFullPath($FilePath)
$utf8Bytes = [Text.Encoding]::UTF8.GetBytes($fullPath)
$base64Path = [Convert]::ToBase64String($utf8Bytes)
$base64CharCodes = (($base64Path.ToCharArray() | ForEach-Object {
    [int] $_
}) -join ' ')
$elisp = "(find-file (decode-coding-string (base64-decode-string (string $base64CharCodes)) 'utf-8))"

& $client --no-wait --server-file $serverName --eval $elisp | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "emacsclient failed with exit code $LASTEXITCODE"
}
