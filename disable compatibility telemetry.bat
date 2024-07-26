:: Author: tsgrgo
:: Disable Microsoft Compatibility Telemetry
@echo off
if not "%1"=="admin" (powershell start -verb runas '%0' admin & exit /b)

for %%i in (DiagTrack) do (
	net stop %%i
	sc config %%i start= disabled
	sc failure %%i reset= 0 actions= ""
)

reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry /t REG_DWORD /d 0 /f

powershell -command "Disable-ScheduledTask -TaskName '\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser'"

echo Finished
pause