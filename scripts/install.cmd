@echo off
rem cmd.exe wrapper around install.ps1 — see that file for usage.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" %*
