try{
	choco -v
	Write-Host -ForegroundColor Green "Chocolatey installed!"
}
catch{
	Write-Host -ForegroundColor Red "Chocolatey not installed. Installing."
	Set-ExecutionPolicy AllSigned

	# Install choco
	Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

	# Refresh env
	Import-Module $env:ChocolateyInstall\helpers\chocolateyProfile.psm1
	RefreshEnv
}

choco install choco-packages.config -y --ignore-checksums

RefreshEnv

# Install powertoys
winget install --scope machine Microsoft.PowerToys -s winget

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

# Dotnet related
dotnet workload update
dotnet workload install aspire

# WSL
wsl --install
wsl --set-default-version 2

# NodeJs Stuff
corepack enable