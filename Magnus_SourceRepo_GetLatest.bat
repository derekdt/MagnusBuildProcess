@echo off

setlocal EnableDelayedExpansion

set LocalRepoPath="C:\Users\SillyLandmine\Desktop\Dev_Repo\DR2015\NubbleSpaceProgram\"

:: Push the current directory path onto a stack and change the current directory path to %LocalRepoPath%
pushd %LocalRepoPath%

echo Fetching Latest from origin!

git fetch origin

if %ERRORLEVEL% NEQ 0 ( 
	echo [UNSUCCESSFUL] - Error %ERRORLEVEL% during git fetch origin command
	goto :Finish
) else (
	echo Fetch successful!
)

echo Removing Local Changes from Config
git checkout Config\

echo Pulling Latest

git pull

if %ERRORLEVEL% NEQ 0 ( 
	echo [UNSUCCESSFUL] - Error %ERRORLEVEL% during git pull command
	goto :Finish
) else (
	echo Pull Successful!
)

:Finish

popd

endlocal