@echo off
title Zetron DCS5020 Dispatch Simulator
echo ===================================================
echo   Zetron DCS5020 Antarctic Dispatch Console
echo ===================================================
echo Starting local console server on port 8080...

:: Check if Python is available
where python >nul 2>nul
if %errorlevel% equ 0 (
    echo Python found. Starting Python HTTP server...
    start "" "http://localhost:8080/index.html"
    python -m http.server 8080
    goto :eof
)

:: Check if Python3 is available
where python3 >nul 2>nul
if %errorlevel% equ 0 (
    echo Python3 found. Starting Python HTTP server...
    start "" "http://localhost:8080/index.html"
    python3 -m http.server 8080
    goto :eof
)

:: Fallback: PowerShell built-in HTTP server (works on any modern Windows 10/11 with zero installs)
echo Launching via built-in Windows PowerShell server...
powershell.exe -ExecutionPolicy Bypass -NoProfile -Command ^
    "$port = 8080; ^
    $listener = New-Object System.Net.HttpListener; ^
    $listener.Prefixes.Add(\"http://localhost:$port/\"); ^
    $listener.Start(); ^
    Write-Host 'Console running at http://localhost:8080/index.html'; ^
    Start-Process 'http://localhost:8080/index.html'; ^
    while ($listener.IsListening) { ^
        $context = $listener.GetContext(); ^
        $req = $context.Request; ^
        $resp = $context.Response; ^
        $localPath = Join-Path $PWD ($req.Url.LocalPath.TrimStart('/')); ^
        if ([string]::IsNullOrWhiteSpace($req.Url.LocalPath) -or $req.Url.LocalPath -eq '/') { $localPath = Join-Path $PWD 'index.html' }; ^
        if (Test-Path $localPath -PathType Leaf) { ^
            $bytes = [System.IO.File]::ReadAllBytes($localPath); ^
            if ($localPath.EndsWith('.html')) { $resp.ContentType = 'text/html' } ^
            elseif ($localPath.EndsWith('.js')) { $resp.ContentType = 'application/javascript' } ^
            elseif ($localPath.EndsWith('.css')) { $resp.ContentType = 'text/css' }; ^
            $resp.ContentLength64 = $bytes.Length; ^
            $resp.OutputStream.Write($bytes, 0, $bytes.Length); ^
        } else { ^
            $resp.StatusCode = 404; ^
        }; ^
        $resp.Close(); ^
    }"
