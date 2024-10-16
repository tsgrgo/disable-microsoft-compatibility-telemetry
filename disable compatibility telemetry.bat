:: Author: tsgrgo
:: Disable Microsoft Compatibility Telemetry
@echo off
setlocal enabledelayedexpansion
if not "%1"=="admin" (powershell start -verb runas '%0' admin & exit /b)

:: Disable related services
for %%i in (DiagTrack) do (
	net stop %%i
	sc config %%i start= disabled
	sc failure %%i reset= 0 actions= ""
)

:: Brute force rename services (_BAK might exist from other scripts)
pushd C:\Windows\System32
for %%i in (CompatTelRunner) do (
	set old=%%i.exe
	set bak=%%i_BAK.exe

	if exist !old! (
		if exist !bak! (
			takeown /f !bak! && icacls !bak! /grant *S-1-1-0:F
			del /f /q !bak!
		)

		takeown /f !old! && icacls !old! /grant *S-1-1-0:F
		rename !old! !bak!
		icacls !bak! /setowner "NT SERVICE\TrustedInstaller" && icacls !bak! /remove *S-1-1-0
	)
)

:: Update registry
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry /t REG_DWORD /d 0 /f

:: Disable telemetry sheduled tasks
powershell -command "Disable-ScheduledTask -TaskName '\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser'"

echo Finished
pause