@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Compound AI Team edition installer (Windows cmd).
REM Mirrors team/install/install.py for Windows hosts.

set "AUTO=0"
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

for %%I in ("%SCRIPT_DIR%\..\..") do set "KIT_ROOT=%%~fI"
set "REGISTRY_TEMPLATE=%KIT_ROOT%\team\team-router\templates\routing-registry.md"

:parse_args
if "%~1"=="" goto args_done
if /I "%~1"=="--yes" set "AUTO=1" & shift & goto parse_args
if /I "%~1"=="-y" set "AUTO=1" & shift & goto parse_args
if /I "%~1"=="--auto" set "AUTO=1" & shift & goto parse_args
if /I "%~1"=="--non-interactive" set "AUTO=1" & shift & goto parse_args
if /I "%~1"=="--help" goto show_help
if /I "%~1"=="-h" goto show_help
echo install.bat: unknown argument: %~1 >&2
goto show_help

:show_help
echo Usage: install.bat [--yes^|-y^|--auto^|--non-interactive]
echo.
echo Copies the Compound AI kit into a "Compound AI" folder under your cloud-docs
echo root, creates a Teams area in your notes root, and writes a routing registry.
exit /b 2

:args_done

call :say "Compound AI Team edition installer"
call :say "----------------------------------"
call :say "This copies the kit into your cloud docs and gives your distilled"
call :say "team notes a home. It never deletes anything and asks before overwriting."
echo.

set "DOCS_DEFAULT=%CD%"
if "%AUTO%"=="1" (
  set "DOCS_RAW=!DOCS_DEFAULT!"
  call :say_prompt "Where do your online documents live, for example a OneDrive folder?" "!DOCS_DEFAULT!" "!DOCS_RAW!"
) else (
  set /p "DOCS_RAW=Where do your online documents live, for example a OneDrive folder? [!DOCS_DEFAULT!]: "
  if "!DOCS_RAW!"=="" set "DOCS_RAW=!DOCS_DEFAULT!"
)

for %%I in ("!DOCS_RAW!") do set "DOCS_ROOT=%%~fI"
set "KIT_DST=!DOCS_ROOT!\Compound AI"

echo.
call :say "Will copy the kit into: !KIT_DST!"
if "%AUTO%"=="1" (
  call :say_yes_result "Proceed?" 1
) else (
  call :ask_yes "Proceed?" 1
  if errorlevel 1 (
    call :say "Stopped. Nothing was written."
    exit /b 1
  )
)

if not exist "!KIT_DST!" mkdir "!KIT_DST!"
call :copy_tree "%KIT_ROOT%" "!KIT_DST!"
if errorlevel 1 exit /b 1

echo.
set "NOTES_DEFAULT=%CD%"
if "%AUTO%"=="1" (
  set "NOTES_RAW=!NOTES_DEFAULT!"
  call :say_prompt "Where is your Obsidian or notes root?" "!NOTES_DEFAULT!" "!NOTES_RAW!"
) else (
  set /p "NOTES_RAW=Where is your Obsidian or notes root? [!NOTES_DEFAULT!]: "
  if "!NOTES_RAW!"=="" set "NOTES_RAW=!NOTES_DEFAULT!"
)

for %%I in ("!NOTES_RAW!") do set "NOTES_ROOT=%%~fI"
echo.
call :say "Will create a Teams area in: !NOTES_ROOT!"
if "%AUTO%"=="1" (
  call :setup_teams_area "!NOTES_ROOT!"
) else (
  call :ask_yes "Proceed?" 1
  if not errorlevel 1 (
    call :setup_teams_area "!NOTES_ROOT!"
  ) else (
    call :say "Skipped the Teams area."
  )
)

echo.
call :setup_routing "!KIT_DST!"

set "ADAPTER=!KIT_DST!\runtime\claude-code\install-adapter.sh"
echo.
call :say "Claude Code wiring (optional): enforcement gates are shell scripts."
call :say "  From Git Bash or WSL:"
call :say "    bash \"!ADAPTER!\" --dry-run"
call :say "    bash \"!ADAPTER!\" --install"

set "CC=!KIT_DST!\team\command-center\refresh.py"
echo.
call :say "Done. Installed kit root:"
call :say "  !KIT_DST!"
echo.
call :say "Verify the install (Git Bash or WSL):"
call :say "  bash \"!KIT_DST!\enforcement\bin\check-kit.sh\" \"!KIT_DST!\""
echo.
call :say "Next steps:"
call :say "  1. Point your AI at this folder: !KIT_DST!"
call :say "  2. Paste raw intake and ask it to run team-router."
call :say "  3. Build the Command Center dashboard:"
call :say "     python \"!CC!\""
call :say "     Open the HTML it writes next to task_state.json."
echo.
call :say "You own the notes. The model is rented and swappable."
exit /b 0

:say
echo %~1
exit /b 0

:say_prompt
echo %~1 [%~2] -^> %~3
exit /b 0

:ask_yes
set "DEFAULT_YES=%~2"
set "REPLY="
set /p "REPLY=%~1 (Y/n): "
if "!REPLY!"=="" if "%DEFAULT_YES%"=="1" exit /b 0
if "!REPLY!"=="" exit /b 1
if /I "!REPLY!"=="Y" exit /b 0
if /I "!REPLY!"=="YEs" exit /b 0
exit /b 1

:say_yes_result
if "%~2"=="1" (
  echo %~1 ^(Y/n^) -^> yes
) else (
  echo %~1 ^(y/N^) -^> no
)
exit /b 0

:setup_teams_area
set "TEAMS_DIR=%~1\Teams"
if not exist "!TEAMS_DIR!" mkdir "!TEAMS_DIR!"
set "README=!TEAMS_DIR!\README.md"
if exist "!README!" (
  call :say "  kept existing Teams\README.md"
  exit /b 0
)
> "!README!" (
  echo # Teams
  echo.
  echo This is where distilled team content lives. team-router writes here:
  echo a living ledger per workstream, a dated daily log, and lineage links
  echo back to the raw source it came from.
  echo.
  echo You own these notes. The AI model is rented and swappable.
)
call :say "  wrote Teams\README.md"
exit /b 0

:setup_routing
set "REGISTRY_DST=%~1\team\team-router\templates\routing-registry.md"
for %%I in ("%REGISTRY_DST%") do if not exist "%%~dpI" mkdir "%%~dpI"
if "%AUTO%"=="1" (
  call :say "Routing: using the starter team structure."
  copy /Y "%REGISTRY_TEMPLATE%" "%REGISTRY_DST%" >nul
  call :say "  wrote routing-registry.md (starter)"
  exit /b 0
)
echo.
call :say "Routing setup. Two choices:"
call :say "  1. Starter team structure (Platform, Data, Adoption). Fast."
call :say "  2. Edit routing-registry.md after install."
echo.
call :ask_yes "Use the starter team structure?" 1
if errorlevel 1 (
  call :say "  Skipped starter registry. Copy the template manually:"
  call :say "    %REGISTRY_TEMPLATE%"
  exit /b 0
)
copy /Y "%REGISTRY_TEMPLATE%" "%REGISTRY_DST%" >nul
call :say "  wrote routing-registry.md (starter)"
exit /b 0

:should_skip
set "REL=%~1"
echo !REL! | findstr /I /R "\.pyc$" >nul && exit /b 0
echo !REL! | findstr /I /C:"\.git\" >nul && exit /b 0
echo !REL! | findstr /I /C:"\__pycache__\" >nul && exit /b 0
echo !REL! | findstr /I /C:"\reference-impl\" >nul && exit /b 0
echo !REL! | findstr /I /C:"\derive\" >nul && exit /b 0
echo !REL! | findstr /I /C:"\leak-denylist.local.txt" >nul && exit /b 0
exit /b 1

:copy_tree
set "SRC=%~1"
set "DST=%~2"
for /R "%SRC%" %%F in (*) do (
  set "FULL=%%F"
  set "REL=!FULL:%SRC%\=!"
  call :should_skip "!REL!"
  if errorlevel 1 (
    set "TARGET=!DST!\!REL!"
    for %%D in ("!TARGET!") do if not exist "%%~dpD" mkdir "%%~dpD"
    if exist "!TARGET!" (
      if "%AUTO%"=="0" (
        set "REPLY="
        set /p "REPLY=Overwrite existing !REL!? (y/N): "
        if /I not "!REPLY!"=="Y" if /I not "!REPLY!"=="YES" (
          call :say "  kept existing !REL!"
        ) else (
          copy /Y "%%F" "!TARGET!" >nul
          call :say "  copied !REL!"
        )
      ) else (
        copy /Y "%%F" "!TARGET!" >nul
        call :say "  copied !REL!"
      )
    ) else (
      copy /Y "%%F" "!TARGET!" >nul
      call :say "  copied !REL!"
    )
  )
)
exit /b 0
