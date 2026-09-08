@echo off
setlocal
cd /d "%~dp0"

set "CLAUDE_NO_RC_SETTINGS=%TEMP%\claude-no-rc-%RANDOM%%RANDOM%.json"

> "%CLAUDE_NO_RC_SETTINGS%" echo {"remoteControlAtStartup":false}

echo Starting Claude Code with Remote Control disabled...
echo Working directory: %CD%
echo.

claude --settings "%CLAUDE_NO_RC_SETTINGS%"
set "EXITCODE=%ERRORLEVEL%"

del /q "%CLAUDE_NO_RC_SETTINGS%" >nul 2>&1

if not "%EXITCODE%"=="0" (
    echo.
    echo Claude exited with error code %EXITCODE%.
    pause
)

endlocal
exit /b %EXITCODE%
