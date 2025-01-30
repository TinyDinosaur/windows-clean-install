$installChocoDeps = $true
$installVSCodeExtensions = $false

if ($installChocoDeps) {
    try {
        choco -v
        Write-Host -ForegroundColor Green "Chocolatey installed!"
    }
    catch {
        Write-Host -ForegroundColor Red "Chocolatey not installed. Installing."
        Set-ExecutionPolicy AllSigned
	
        # Install choco
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
	
        # Refresh env
        Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
        RefreshEnv
    }
	
    choco install choco-packages.config -y --ignore-checksums
}

Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1

RefreshEnv

# Install powertoys
winget install --scope machine Microsoft.PowerToys -s winget

if ($installVSCodeExtensions) {
    # Install vscode extensions
    code --install-extension ms-vscode.cpptools
    code --install-extension ms-dotnettools.csharp
    code --install-extension redhat.vscode-yaml
    code --install-extension ms-dotnettools.csdevkit
    code --install-extension ms-vscode.powershell
    code --install-extension redhat.vscode-xml
    code --install-extension platformio.platformio-ide
    code --install-extension github.copilot
    code --install-extension github.copilot-chat
    code --install-extension ms-vscode.vscode-typescript-next
}

# Set custom VSCode keybindings
$sourceKeybindings = "vscode/keybindings.json"
$targetKeybindings = "$env:APPDATA\Code\User\keybindings.json"

if (Test-Path $sourceKeybindings) {
    Copy-Item -Path $sourceKeybindings -Destination $targetKeybindings -Force
    Write-Host "VSCode keybindings have been set." -ForegroundColor Green
} else {
    Write-Host "Source keybindings file not found." -ForegroundColor Red
}


# Dotnet related
dotnet workload update
dotnet workload install aspire

## Azure artifacts credential provider https://github.com/microsoft/artifacts-credprovider
iex "& { $(irm https://aka.ms/install-artifacts-credprovider.ps1) } -AddNetfx"

# WSL
$wslInstallation = wsl -l | Where { $_.Replace("`0", "") -match '^Ubuntu' }

if ($wslInstallation) {
    Write-Host "WSL distro found: $wslInstallation, skipping WSL installation" -ForegroundColor Green
}
else {
    Write-Host "Installing WSL Distro" -ForegroundColor Yellow
    wsl --install
    wsl --set-default-version 2
}

# Move autohotkey scripts to user scripts so they can run on startup

$autoHotKeyScriptTargetFile = "$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\MainScript.ahk"

if (!(Test-Path $autoHotKeyScriptTargetFile)) {
    New-Item -Path $autoHotKeyScriptTargetFile -ItemType SymbolicLink -Value ./MainScript.ahk -Force
}

# NodeJs Stuff
corepack enable


RefreshEnv