@echo off
SET SCRIPT_HOME=%~dp0
SET VENV_PATH=%SCRIPT_HOME%\update_filterblocks.venv
call "%VENV_PATH%\Scripts\activate"
CD /D %SCRIPT_HOME%
python update_filterblocks.py
pause