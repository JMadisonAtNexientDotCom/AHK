CD C:\DEV\AHK\CODE_SNIPPET\NEXIENT_PROJECTS\GAUNTLET_UI\BAT
call ReBuild.bat REM call runs .bat before other scripts are started.

CD C:\DEV\AHK\CODE_SNIPPET\NEXIENT_PROJECTS\GAUNTLET_UI\BAT
start BootUp_01.bat
start BootUp_02.bat

echo Use start rather than call, because call waits for first bat to finish.