$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

$BackPath = Join-Path $ScriptDir "back"
$FrontPath = Join-Path $ScriptDir "front\pfeapp"

if (-not (Test-Path $BackPath)) { $BackPath = Join-Path $ScriptDir "palchat\back" }
if (-not (Test-Path $FrontPath)) { $FrontPath = Join-Path $ScriptDir "palchat\front\pfeapp" }

if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
    $DefaultAdbPath = "$env:LOCALAPPDATA\Android\Sdk\platform-tools"
    if (Test-Path $DefaultAdbPath) {
        $env:Path += ";$DefaultAdbPath"
    } else {
        Write-Error "Could not find Android SDK Platform tools. Please ensure Android Studio is installed."
        Exit
    }
}

Set-Location $ScriptDir
flutter emulators --launch Medium_Phone_API_36.1

if (Test-Path $FrontPath) {
    Set-Location $FrontPath
    Write-Output "Starting Flutter app in the background..."
    Start-Job -ScriptBlock { flutter run -d emulator-5554 --no-pub --suppress-analytics } | Out-Null
} else {
    Write-Error "Cannot find the Flutter folder at: $FrontPath"
    Exit
}

if (Test-Path $BackPath) {
    Set-Location $BackPath
    Write-Output "Streaming Django Server Logs:"
    docker-compose up
} else {
    Write-Error "Cannot find the backend folder at: $BackPath"
    Exit
}