:: Author: tsgrgo
:: Disable Microsoft Compatibility Telemetry
@echo off
setlocal enabledelayedexpansion
if not "%1"=="admin" (powershell start -verb runas '%0' admin & exit /b)

sc config DiagTrack start= auto

:: Restore renamed services
pushd C:\Windows\System32
for %%i in (CompatTelRunner) do (
	set old=%%i.exe
	set bak=%%i_BAK.exe
	takeown /f !bak! && icacls !bak! /grant *S-1-1-0:F
	rename !bak! !old!
	icacls !old! /setowner "NT SERVICE\TrustedInstaller" && icacls !old! /remove *S-1-1-0
)

reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry /f

powershell -command "Enable-ScheduledTask -TaskName '\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser'"

echo Finished
pause