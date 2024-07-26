:: Author: tsgrgo
:: Disable Microsoft Compatibility Telemetry
@echo off
if not "%1"=="admin" (powershell start -verb runas '%0' admin & exit /b)

sc config DiagTrack start= auto

reg delete HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection /v AllowTelemetry /f

powershell -command "Enable-ScheduledTask -TaskName '\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser'"

echo Finished
pause