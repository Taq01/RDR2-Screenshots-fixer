@echo off
setlocal
cd /d "%~dp0"

echo Scanning for RDR2 photos...
echo.


powershell -Command "& { " ^
    "$files = Get-ChildItem 'PRDR*';" ^
    "foreach ($f in $files) {" ^
    "    try {" ^
    "        $bytes = [System.IO.File]::ReadAllBytes($f.FullName);" ^
    "        $start = 0;" ^
    "        for ($i = 0; $i -lt ($bytes.Length - 1); $i++) {" ^
    "            if ($bytes[$i] -eq 0xFF -and $bytes[$i+1] -eq 0xD8) {" ^
    "                $start = $i;" ^
    "                break;" ^
    "            }" ^
    "        }" ^
    "        if ($start -gt 0) {" ^
    "            $newBytes = $bytes[$start..($bytes.Length - 1)];" ^
    "            $newName = $f.BaseName + '_fixed.jpg';" ^
    "            [System.IO.File]::WriteAllBytes($newName, $newBytes);" ^
    "            Write-Host 'Fixed: ' $f.Name ' -> ' $newName -ForegroundColor Green;" ^
    "        } else {" ^
    "            Write-Host 'Skipping ' $f.Name ' (No hidden image found)' -ForegroundColor Yellow;" ^
    "        }" ^
    "    } catch {" ^
    "        Write-Host 'Error reading ' $f.Name -ForegroundColor Red;" ^
    "    }" ^
    "}" ^
"}"

echo.
pause