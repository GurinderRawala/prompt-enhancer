# Setup on Windows

## Step 1
To download and run the app on Windows, open the PowerShell terminal and copy-paste this command:

```powershell
# OmniKey-AI Windows bootstrap script (HTTPS-only + DOTNET_ROOT fix)
# Run in Windows Terminal (PowerShell)

$ErrorActionPreference = "Stop"

function Ensure-Command($name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    throw "Required command not found: $name"
  }
}

function Write-Header($msg) {
  Write-Host ""
  Write-Host "==> $msg" -ForegroundColor Cyan
}

try {
  Write-Header "Setting PowerShell execution policy for current user"
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

  # Install Scoop if missing
  if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Header "Installing Scoop"
    Invoke-RestMethod -Uri "https://get.scoop.sh" | Invoke-Expression
  } else {
    Write-Header "Scoop already installed"
  }

  Write-Header "Updating Scoop"
  scoop update

  Write-Header "Installing dependencies (git, nodejs, yarn, dotnet-sdk)"
  scoop install git nodejs yarn dotnet-sdk

  # -------------------------------------------------
  # Set DOTNET_ROOT permanently
  # -------------------------------------------------
  Write-Header "Setting DOTNET_ROOT environment variable"

  $dotnetRoot = Join-Path $HOME "scoop\apps\dotnet-sdk\current"

  if (-not (Test-Path $dotnetRoot)) {
    throw "dotnet-sdk installation not found at expected path: $dotnetRoot"
  }

  # Set permanently for user
  setx DOTNET_ROOT "$dotnetRoot" | Out-Null

  # Also set for current session
  $env:DOTNET_ROOT = $dotnetRoot

  Write-Host "DOTNET_ROOT set to: $dotnetRoot" -ForegroundColor Green

  # Refresh PATH
  $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","User") + ";" +
              [System.Environment]::GetEnvironmentVariable("PATH","Machine")

  Ensure-Command git
  Ensure-Command node
  Ensure-Command yarn
  Ensure-Command dotnet

  Write-Header "Cloning public repo via HTTPS"
  $repoHttps = "https://github.com/GurinderRawala/OmniKey-AI.git"
  $targetDir = "OmniKey-AI"

  if (-not (Test-Path $targetDir)) {
    git clone $repoHttps
  } else {
    Write-Host "Repo folder '$targetDir' already exists. Skipping clone." -ForegroundColor Yellow
  }

  # Absolute repo root
  $repoRoot = (Resolve-Path $targetDir).Path

  Write-Header "Installing JS dependencies (yarn install)"
  Push-Location $repoRoot
  yarn install
  Pop-Location

  Write-Header "Prompting for OPENAI_API_KEY"
  $secureKey = Read-Host "Enter OPENAI_API_KEY" -AsSecureString
  $plainKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureKey)
  )

  if ([string]::IsNullOrWhiteSpace($plainKey)) {
    throw "OPENAI_API_KEY cannot be empty."
  }

  Write-Header "Creating .env at repo root"
  $envPath = Join-Path $repoRoot ".env"
  "OPENAI_API_KEY=$plainKey" | Out-File -FilePath $envPath -Encoding utf8 -Force

  Write-Header "Building C# tray app (dotnet build)"
  $windowsDir = Join-Path $repoRoot "windows"

  if (-not (Test-Path $windowsDir)) {
    throw "Expected folder not found: $windowsDir"
  }

  Push-Location $windowsDir
  dotnet build
  Pop-Location

  Write-Host ""
  Write-Host "✅ Done. Repo set up and dotnet build completed." -ForegroundColor Green
  Write-Host "📄 .env created at: $envPath" -ForegroundColor Gray
  Write-Host "🔁 You may need to restart terminal for permanent DOTNET_ROOT to take effect." -ForegroundColor Yellow

} catch {
  Write-Host ""
  Write-Host "❌ Failed: $($_.Exception.Message)" -ForegroundColor Red
  exit 1
}
```

## Step 2

Restart PowerShell and run this command.

```powershell 
cd OmniKey-AI

yarn dev:windows

```

