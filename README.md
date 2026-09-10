# Claude Code — No Remote Control Launcher

A small Windows batch-file launcher for starting **one Claude Code session without automatically connecting to Remote Control**.

This is useful if you normally have Claude Code's **"Enable Remote Control for all sessions"** option enabled, but occasionally want to launch a terminal-only session without changing your permanent Claude Code settings.

## What it does

`Start-Claude-No-Remote-Control.bat`:

1. Changes the working directory to the folder containing the batch file.
2. Creates a temporary Claude Code settings file.
3. Sets:

   ```json
   {
     "remoteControlAtStartup": false
   }
   ```

4. Starts Claude Code with that temporary settings file using `--settings`.
5. Deletes the temporary file after Claude Code exits.

Your normal Claude Code settings are left unchanged.

## Requirements

- Windows
- Claude Code installed
- The `claude` command available in your system `PATH`

You can confirm Claude Code is available by opening PowerShell or Command Prompt and running:

```powershell
claude --version
```

## Installation

Download or clone this repository, then copy:

```text
Start-Claude-No-Remote-Control.bat
```

into the root folder of any project where you want to use it.

Example:

```text
Gratitude-Garden/
├── Start-Claude-No-Remote-Control.bat
├── app/
├── gradle/
├── build.gradle.kts
└── ...
```

## Usage

Simply double-click:

```text
Start-Claude-No-Remote-Control.bat
```

A terminal window will open and Claude Code will start in the same folder as the batch file.

When Claude Code exits, the temporary settings file is automatically removed.

The next time you launch Claude normally:

```powershell
claude
```

your regular Remote Control setting will apply again.

## Batch file

```bat
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
```

## Important distinction

This launcher disables **automatic Remote Control connection at startup** for the launched Claude Code session.

It does **not** make Claude Code offline. Claude Code still communicates with Anthropic's services to run the model.

It also does not permanently disable the Remote Control feature itself. If you explicitly run `/remote-control` or `/rc` from inside the session, Remote Control can still be started.

## Using it without committing it to another project

If you copy the batch file into another Git repository but do not want to commit it there, add this to that repository's `.gitignore`:

```gitignore
/Start-Claude-No-Remote-Control.bat
```

If Git is already tracking the file, remove it from Git's index without deleting the local copy:

```bash
git rm --cached Start-Claude-No-Remote-Control.bat
```

## Why use a temporary settings file?

Claude Code supports the `--settings` option for applying settings to a single launch without modifying your normal settings files.

Using a temporary JSON file also avoids quoting and escaping issues that can occur when passing inline JSON from Windows PowerShell.

## Official documentation

- [Claude Code Remote Control](https://code.claude.com/docs/en/remote-control)
- [Claude Code settings and precedence](https://code.claude.com/docs/en/settings)

## License

If you plan to publish the repository publicly, consider adding a standard license such as the MIT License.
