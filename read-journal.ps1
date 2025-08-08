# Script USN Journal Monitor
# Codifica: UTF-8 with BOM
# Autori: usnjournal. & onlynelchilling

$Script:Config = @{
    OutputFile = "waaz.txt"
    SpoofedFile = "spoofed_replaces.txt"
    Colors = @{
        Primary = "Cyan"
        Secondary = "White"
        Success = "Green"
        Warning = "Yellow"
        Error = "Red"
        Accent = "DarkRed"
    }
    LogoLines = @(
        "   ██████╗ ███████╗█████╗  ██████╗          ██╗ ██████╗ ██╗   ██╗██████╗ ███╗   ██╗█████╗  ██╗     ",
        "   ██╔══██╗██╔════╝██╔══██╗██╔══██╗         ██║██║   ██║██║   ██║██╔══██╗████╗  ██║██╔══██╗██║     ",
        "   ██████╔╝█████╗  ███████║██║  ██║         ██║██║   ██║██║   ██║██████╔╝██╔██╗ ██║███████║██║     ",
        "   ██╔══██╗██╔══╝  ██╔══██║██║  ██║    ██   ██║██║   ██║██║   ██║██╔══██╗██║╚██╗██║██╔══██║██║     ",
        "   ██║  ██║███████╗██║  ██║██████╔╝    ╚█████╔╝╚██████╔╝╚██████╔╝██║  ██║██║ ╚████║██║  ██║███████╗",
        "   ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝      ╚════╝  ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚══════╝",
        "",
        "                                    Developed by usnjournal. & onlynelchilling"
    )
    FileExtensions = @{
        Executables = @(".exe", ".bat", ".cmd", ".jar", ".pif")
        Minecraft = @(".mcf", ".log", ".log.gz")
        Archives = @(".zip", ".rar", ".7z", ".tar", ".gz")
        Python = @(".py", ".pyc", ".pyo")
        Logs = @("latest.log", ".log.gz", "launcher_profiles.json", "usernamecache.json", "usercache.json", "shig.inima", "launcher_accounts.json")
        SafeExtensions = @(".3dm", ".3ds", ".blend", ".dae", ".fbx", ".max", ".obj", ".stp", ".step", ".3gp", ".3g2", ".asf", ".avi", ".flv", ".m4v", ".mov", ".mp4", ".mpg", ".ts", ".vob", ".webm", ".wmv", ".mp3", ".wma", ".flac", ".aif", ".m4a", ".mid", ".midi", ".ogg", ".wav", ".m3u", ".srt", ".sub", ".txt", ".rtf", ".doc", ".docx", ".odt", ".pages", ".pdf", ".ppt", ".pptx", ".potx", ".pptm", ".pps", ".ppsx", ".odp", ".xls", ".xlsx", ".xlsm", ".xlsb", ".xlt", ".xltm", ".ods", ".xlr", ".csv", ".tsv", ".db", ".dbf", ".accdb", ".mdb", ".sql", ".sqlite", ".pdb", ".xml", ".json", ".yml", ".yaml", ".htm", ".html", ".xhtml", ".asp", ".aspx", ".cfm", ".php", ".php3", ".php4", ".jsp", ".js", ".css", ".scss", ".csr", ".crx", ".plugin", ".xpi", ".ai", ".cdr", ".svg", ".emf", ".eps", ".psd", ".ps", ".ico", ".cur", ".ani", ".bmp", ".gif", ".png", ".jpg", ".jpeg", ".heic", ".raw", ".nef", ".nrw", ".orf", ".mrw", ".raf", ".erf", ".srf", ".dds", ".djvu", ".ppm", ".pbm", ".pgm", ".pcx", ".sketch", ".vsdx", ".dwg", ".dxf", ".indd", ".oxps", ".prf", ".cfg", ".ini", ".log", ".tmp", ".bed", ".bak", ".arc", ".zipx", ".tar.gz", ".arj", ".deb", ".apk", ".ipa", ".appx", ".app", ".run", ".msi", ".com", ".sh", ".ps1", ".vbs", ".wsf", ".lnk", ".url", ".iso", ".bin", ".img", ".mdf", ".mobi", ".epub", ".azw", ".azw3", ".pak", ".mdl", ".rom", ".dem", ".sav", ".torrent", ".crdownload", ".part", ".nomedia", ".pkpass", ".md", ".pif", ".pf", ".prt", ".prg", ".res", ".drv", ".fon", ".fot", ".hlp", ".ctf", ".gho")
    }
    UsnReasons = @{
        DataOverwrite = "0x00000001"
        DataExtend = "0x00000002"
        TruncateDataSize = "0x00000004"
        CreateOrClose = "0x00000100"
        DeleteFile = "0x00000200"
        PropertyChange = "0x00001000"
        Renamed = "0x00002000"
        FileCreate = "0x00000100"
        HardLinkChange = "0x00010000"
        StreamChange = "0x00200000"
        ObjectIdChange = "0x00080000"
        CompressionChange = "0x00020000"
        EncryptionChange = "0x00040000"
        SecurityChange = "0x00100000"
        EaChange = "0x00000400"
        ReparsePointChange = "0x10000000"
        BasicInfoChange = "0x00008000"
        Close = "0x80000000"
        ReplaceOperation = "0x80000006"
        DeleteOrMove = "0x80000200"
        ReadOnlyChange = "0x80008000"
    }
}

function Write-ColoredMessage {
    param(
        [string]$Message,
        [string]$Color = $Script:Config.Colors.Primary,
        [switch]$NoNewline
    )
    
    $validColors = [System.Enum]::GetNames([System.ConsoleColor])
    if (-not $validColors -contains $Color) {
        $Color = $Script:Config.Colors.Primary
    }
    
    if ($NoNewline) {
        Write-Host $Message -ForegroundColor $Color -NoNewline
    } else {
        Write-Host $Message -ForegroundColor $Color
    }
}

function Show-CenteredText {
    param([string]$Text, [string]$Color = $Script:Config.Colors.Primary)
    
    $width = $Host.UI.RawUI.BufferSize.Width
    $padding = [Math]::Max(0, [int](($width - $Text.Length) / 2))
    Write-ColoredMessage (" " * $padding + $Text) -Color $Color
}

function Test-OutputFile {
    param([string]$FilePath)
    
    return (Test-Path $FilePath) -and ((Get-Item $FilePath).Length -gt 0)
}

function Open-ResultFile {
    param([string]$FilePath, [string]$Description = "Results")
    
    if (Test-OutputFile $FilePath) {
        Write-ColoredMessage "$Description saved to $FilePath" -Color $Script:Config.Colors.Success
        try {
            Start-Process notepad.exe $FilePath -ErrorAction Stop
        } catch {
            Write-ColoredMessage "Warning: Could not open $FilePath automatically" -Color $Script:Config.Colors.Warning
        }
    } else {
        Write-ColoredMessage "No results found" -Color $Script:Config.Colors.Warning
    }
}

function Invoke-UsnQuery {
    param(
        [string[]]$Reasons,
        [string[]]$Extensions = @(),
        [string[]]$Keywords = @(),
        [string]$DateFilter = "",
        [string]$OutputFile = $Script:Config.OutputFile,
        [switch]$Append
    )
    
    try {
        $reasonFilter = ($Reasons | ForEach-Object { "/C:`"$_`"" }) -join " "
        $baseCmd = "fsutil usn readjournal c: csv | findstr /i $reasonFilter"
        
        if ($DateFilter) {
            $baseCmd += " | findstr /i /C:`"$DateFilter`""
        }
        
        if ($Extensions.Count -gt 0 -or $Keywords.Count -gt 0) {
            $allFilters = @()
            $allFilters += $Extensions | ForEach-Object { "/C:`"$_`"" }
            $allFilters += $Keywords | ForEach-Object { "/C:`"$_`"" }
            $filterString = $allFilters -join " "
            $baseCmd += " | findstr /i $filterString"
        }
        
        $redirector = if ($Append) { ">>" } else { ">" }
        $fullCmd = "$baseCmd $redirector $OutputFile"
        
        Invoke-Expression $fullCmd
        
        return $true
    } catch {
        Write-ColoredMessage "Error executing USN query: $($_.Exception.Message)" -Color $Script:Config.Colors.Error
        return $false
    }
}

function Show-AnimatedLogo {
    Clear-Host
    
    foreach ($line in $Script:Config.LogoLines) {
        if ($line -match "Developed by") {
            Show-CenteredText $line -Color $Script:Config.Colors.Accent
        } else {
            Show-CenteredText $line -Color $Script:Config.Colors.Primary
        }
    }
    Start-Sleep -Milliseconds 300
}

function Show-MainMenu {
    Show-AnimatedLogo
    Write-Host ""
    Show-CenteredText "======================================" -Color $Script:Config.Colors.Primary
    Show-CenteredText "       USN JOURNAL MONITOR TOOL      " -Color $Script:Config.Colors.Primary
    Show-CenteredText "======================================" -Color $Script:Config.Colors.Primary
    Write-Host ""
    
    $menuItems = @(
        "1. Replace/Delete/Move Operations",
        "2. Log Files Operations", 
        "3. Minecraft Files",
        "4. Created Executable Files",
        "5. Replace Operations (Today)",
        "6. Read-Only File Operations",
        "7. Spoofed Extensions Detection",
        "8. Python Files Operations",
        "9. Archive Files Operations",
        "10. Spoofed Replace Operations",
        "11. Combined Operations",
        "12. Delete Generated Files",
        "13. Exit"
    )
    
    foreach ($item in $menuItems[0..10]) {
        Show-CenteredText $item -Color $Script:Config.Colors.Primary
    }
    
    foreach ($item in $menuItems[11..12]) {
        Show-CenteredText $item -Color $Script:Config.Colors.Error
    }
    
    Write-Host ""
    return Read-Host "                                    Select an option (1-13)"
}

function Test-ReplaceDeleteMove {
    Write-ColoredMessage "`n--- Replace/Delete/Move Operations ---`n" -Color $Script:Config.Colors.Primary
    Write-ColoredMessage "Checking for executable and suspicious file operations..." -Color $Script:Config.Colors.Secondary
    
    $reasons = @($Script:Config.UsnReasons.DeleteOrMove, $Script:Config.UsnReasons.PropertyChange, $Script:Config.UsnReasons.Renamed)
    $extensions = $Script:Config.FileExtensions.Executables + @(".pf", "jnativehook", "?")
    
    if (Invoke-UsnQuery -Reasons $reasons -Extensions $extensions) {
        Open-ResultFile $Script:Config.OutputFile
    }
}

function Test-LogFiles {
    Write-ColoredMessage "`n--- Log Files Operations ---`n" -Color $Script:Config.Colors.Primary
    Write-ColoredMessage "Checking for log file operations..." -Color $Script:Config.Colors.Secondary
    
    $reasons = @($Script:Config.UsnReasons.DeleteOrMove)
    $keywords = $Script:Config.FileExtensions.Logs
    
    if (Invoke-UsnQuery -Reasons $reasons -Keywords $keywords) {
        Open-ResultFile $Script:Config.OutputFile
    }
}

function Test-MinecraftFiles {
    Write-ColoredMessage "`n--- Minecraft Files ---`n" -Color $Script:Config.Colors.Primary
    Write-ColoredMessage "Checking for Minecraft file operations..." -Color $Script:Config.Colors.Secondary
    
    $reasons = @($Script:Config.UsnReasons.DeleteOrMove)
    $extensions = @(".mcf")
    
    if (Invoke-UsnQuery -Reasons $reasons -Extensions $extensions) {
        Open-ResultFile $Script:Config.OutputFile
    }
}

function Test-CreatedExecutables {
    Write-ColoredMessage "`n--- Created Executable Files ---`n" -Color $Script:Config.Colors.Primary
    Write-ColoredMessage "Checking for newly created executables..." -Color $Script:Config.Colors.Secondary
    
    $reasons = @($Script:Config.UsnReasons.FileCreate)
    $extensions = @(".exe")
    
    if (Invoke-UsnQuery -Reasons $reasons -Extensions $extensions) {
        Open-ResultFile $Script:Config.OutputFile
    }
}

function Test-ReplaceOperations {
    Write-ColoredMessage "`n--- Replace Operations (Today) ---`n" -Color $Script:Config.Colors.Primary
    $currentDate = Get-Date -Format "MM/dd/yyyy"
    Write-ColoredMessage "Checking for file replacements today ($currentDate)..." -Color $Script:Config.Colors.Secondary
    
    $reasons = @($Script:Config.UsnReasons.ReplaceOperation)
    
    if (Invoke-UsnQuery -Reasons $reasons -DateFilter $currentDate) {
        Open-ResultFile $Script:Config.OutputFile
    }
}

function Test-ReadOnlyFiles {
    Write-ColoredMessage "`n--- Read-Only File Operations ---`n" -Color $Script:Config.Colors.Primary
    Write-ColoredMessage "Checking for read-only file operations..." -Color $Script:Config.Colors.Secondary
    
    $reasons = @($Script:Config.UsnReasons.BasicInfoChange, $Script:Config.UsnReasons.ReadOnlyChange)
    $keywords = @("Read-only", "Archive", "Sola lettura", "Archivio")
    
    if (Invoke-UsnQuery -Reasons $reasons -Keywords $keywords) {
        Open-ResultFile $Script:Config.OutputFile
    }
}

function Test-SpoofedExtensions {
    Write-ColoredMessage "`n--- Spoofed Extensions Detection ---`n" -Color $Script:Config.Colors.Primary
    Write-ColoredMessage "Checking for files with spoofed extensions..." -Color $Script:Config.Colors.Secondary
    
    try {
        $result = findstr /m /c:"!This program cannot be run in DOS mode." "*" 2>$null > $Script:Config.OutputFile
        Open-ResultFile $Script:Config.OutputFile "Spoofed extensions"
    } catch {
        Write-ColoredMessage "Error during spoofed extension detection" -Color $Script:Config.Colors.Error
    }
}

function Test-PythonFiles {
    Write-ColoredMessage "`n--- Python Files Operations ---`n" -Color $Script:Config.Colors.Primary
    Write-ColoredMessage "Checking for Python file operations..." -Color $Script:Config.Colors.Secondary
    
    $reasons = @($Script:Config.UsnReasons.DeleteOrMove, $Script:Config.UsnReasons.FileCreate, $Script:Config.UsnReasons.DataOverwrite)
    $extensions = $Script:Config.FileExtensions.Python
    
    if (Invoke-UsnQuery -Reasons $reasons -Extensions $extensions) {
        Open-ResultFile $Script:Config.OutputFile
    }
}

function Test-ArchiveFiles {
    Write-ColoredMessage "`n--- Archive Files Operations ---`n" -Color $Script:Config.Colors.Primary
    $currentDate = Get-Date -Format "MM/dd/yyyy"
    Write-ColoredMessage "Checking for archive file operations today ($currentDate)..." -Color $Script:Config.Colors.Secondary
    
    $reasons = @($Script:Config.UsnReasons.DeleteOrMove, $Script:Config.UsnReasons.PropertyChange, $Script:Config.UsnReasons.Renamed)
    $extensions = $Script:Config.FileExtensions.Archives
    
    if (Invoke-UsnQuery -Reasons $reasons -Extensions $extensions -DateFilter $currentDate) {
        Open-ResultFile $Script:Config.OutputFile
    }
}

function Test-SpoofedReplaceOperations {
    Write-ColoredMessage "`n--- Spoofed Replace Operations ---`n" -Color $Script:Config.Colors.Primary
    Write-ColoredMessage "Checking for replace operations with spoofed extensions..." -Color $Script:Config.Colors.Secondary
    
    try {
        $safeExts = ($Script:Config.FileExtensions.SafeExtensions | ForEach-Object { "\$_" }) -join " "
        $cmd = "fsutil usn readjournal c: csv | findstr /i `"0x00000004`" | findstr /i /r `"\.[^\.]*$ \.[^\.]*\.[^\.]*$`" | findstr /i /v `"$safeExts`" > $($Script:Config.SpoofedFile)"
        
        Invoke-Expression $cmd
        Open-ResultFile $Script:Config.SpoofedFile "Spoofed replace operations"
    } catch {
        Write-ColoredMessage "Error during spoofed replace operation detection" -Color $Script:Config.Colors.Error
    }
}

function Test-CombinedOperations {
    Write-ColoredMessage "`n--- Combined Operations ---`n" -Color $Script:Config.Colors.Primary
    Write-ColoredMessage "Running all monitoring checks together..." -Color $Script:Config.Colors.Secondary
    
    "" | Out-File $Script:Config.OutputFile -Encoding UTF8
    
    $operations = @(
        @{ Name = "Replace/Delete/Move operations"; Function = { Test-ReplaceDeleteMove } },
        @{ Name = "Log files operations"; Function = { Test-LogFiles } },
        @{ Name = "Minecraft files"; Function = { Test-MinecraftFiles } },
        @{ Name = "Created executable files"; Function = { Test-CreatedExecutables } },
        @{ Name = "Replace operations"; Function = { Test-ReplaceOperations } },
        @{ Name = "Read-only file operations"; Function = { Test-ReadOnlyFiles } },
        @{ Name = "Python files operations"; Function = { Test-PythonFiles } },
        @{ Name = "Archive files operations"; Function = { Test-ArchiveFiles } }
    )
    
    $counter = 1
    foreach ($op in $operations) {
        Write-ColoredMessage "$counter. $($op.Name)..." -Color $Script:Config.Colors.Warning
        & $op.Function | Out-Null
        $counter++
    }
    
    Write-ColoredMessage "9. Spoofed extensions detection..." -Color $Script:Config.Colors.Warning
    Test-SpoofedExtensions | Out-Null
    
    Write-ColoredMessage "10. Spoofed replace operations..." -Color $Script:Config.Colors.Warning
    Test-SpoofedReplaceOperations | Out-Null
    
    if (Test-OutputFile $Script:Config.OutputFile) {
        Write-ColoredMessage "All results combined in $($Script:Config.OutputFile)" -Color $Script:Config.Colors.Success
        try {
            Start-Process notepad.exe $Script:Config.OutputFile
        } catch {
            Write-ColoredMessage "Warning: Could not open results file automatically" -Color $Script:Config.Colors.Warning
        }
    } else {
        Write-ColoredMessage "No operations detected across all checks" -Color $Script:Config.Colors.Warning
    }
}

function Remove-GeneratedFiles {
    Write-ColoredMessage "`n--- Deleting Generated Files ---`n" -Color $Script:Config.Colors.Primary
    
    $filesToDelete = @($Script:Config.OutputFile, $Script:Config.SpoofedFile)
    $deletedFiles = @()
    
    foreach ($file in $filesToDelete) {
        if (Test-Path $file) {
            try {
                Remove-Item $file -Force -ErrorAction Stop
                Write-ColoredMessage "Deleted: $file" -Color $Script:Config.Colors.Success
                $deletedFiles += $file
            } catch {
                Write-ColoredMessage "Failed to delete: $file - $($_.Exception.Message)" -Color $Script:Config.Colors.Error
            }
        }
    }
    
    if ($deletedFiles.Count -eq 0) {
        Write-ColoredMessage "No generated files found to delete" -Color $Script:Config.Colors.Warning
    } else {
        Write-ColoredMessage "`nSuccessfully deleted $($deletedFiles.Count) file(s)" -Color $Script:Config.Colors.Success
    }
}

function Show-ExitMessage {
    Clear-Host
    Write-Host ""
    Show-CenteredText "═══════════════════════════════" -Color $Script:Config.Colors.Error
    Show-CenteredText "        Thank you for using    " -Color $Script:Config.Colors.Error
    Show-CenteredText "        USN Journal Monitor    " -Color $Script:Config.Colors.Error
    Show-CenteredText "═══════════════════════════════" -Color $Script:Config.Colors.Error
    Write-Host ""
    Show-CenteredText "Goodbye and happy monitoring!" -Color $Script:Config.Colors.Primary
    Write-Host ""
    Start-Sleep -Seconds 2
}

function Start-UsnMonitor {
    Write-ColoredMessage "Initializing USN Journal Monitor..." -Color $Script:Config.Colors.Primary
    Start-Sleep -Seconds 1

    $functionMap = @{
        "1" = { Test-ReplaceDeleteMove }
        "2" = { Test-LogFiles }
        "3" = { Test-MinecraftFiles }
        "4" = { Test-CreatedExecutables }
        "5" = { Test-ReplaceOperations }
        "6" = { Test-ReadOnlyFiles }
        "7" = { Test-SpoofedExtensions }
        "8" = { Test-PythonFiles }
        "9" = { Test-ArchiveFiles }
        "10" = { Test-SpoofedReplaceOperations }
        "11" = { Test-CombinedOperations }
        "12" = { Remove-GeneratedFiles }
        "13" = { Show-ExitMessage; return $true }
    }

    while ($true) {
        $choice = Show-MainMenu

        if ($functionMap.ContainsKey($choice)) {
            $shouldExit = & $functionMap[$choice]
            if ($shouldExit) { break }
        } else {
            Write-ColoredMessage "Invalid option. Please select a number between 1-13." -Color $Script:Config.Colors.Error
            Start-Sleep -Seconds 2
        }
        
        if ($choice -ne "13") {
            Write-ColoredMessage "`nPress any key to continue..." -Color "Gray"
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    }
}

Start-UsnMonitor
