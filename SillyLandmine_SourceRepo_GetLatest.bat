@echo off

setlocal EnableDelayedExpansion

set LocalRepoPath="C:\Users\SillyLandmine\Desktop\Dev_Repo\DR2015\NubbleSpaceProgram\"

:: Push the current directory path onto a stack and change the current directory path to %LocalRepoPath%
pushd %LocalRepoPath%

git fetch origin

if %ERRORLEVEL% NEQ 0 ( 
	echo ---------[UNSUCCESSFUL] Error %ERRORLEVEL% during git fetch origin command
	goto :Finish
) else (
	echo ---------[SUCCESS] Fetching latest from origin successful!
)

git checkout Config\

echo ---------[SUCCESS] Removing local changes from Config

git pull

if %ERRORLEVEL% NEQ 0 ( 
	echo ---------[UNSUCCESSFUL] Error %ERRORLEVEL% during git pull command
	goto :Finish
) else (
	echo ---------[SUCCESS] Pulled latest revision successful!
)

:Finish

popd

endlocal