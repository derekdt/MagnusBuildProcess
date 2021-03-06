@echo off

setlocal EnableDelayedExpansion
set ProjectName=NubbleSpaceProgram
set LocalRepoPath="C:\Users\SillyLandmine\Desktop\Dev_Repo\DR2015\%ProjectName%"
set UATPath="C:\Jenkins\Magnus\Engines\4.9(4.10)\UnrealEngine\Engine\Build\BatchFiles\RunUAT"
set UProjectPath="C:\Users\SillyLandmine\Desktop\Dev_Repo\DR2015\%ProjectName%\%ProjectName%.uproject"
set P4RepoPath="C:\Users\SillyLandmine\Perforce\Magnus\gamepipe\AGP2015\ADatingSim\"
set P4RepoRootPath="C:\Users\SillyLandmine\Perforce\Magnus"
set DeployedBuildsPath="C:\Users\SillyLandmine\Desktop\Dev_Repo\DR2015\%ProjectName%\Saved\StagedBuilds"
set ClientBuildType=Shipping
set ServerBuildType=Shipping
set Platform=Win64
set BuildName=Ship-PC
set CurrentCommitLongTag=
set CurrentBranchName=
set TSYear=%Date:~10,4%
set TSMonth=%Date:~4,2%
set TSDay=%Date:~7,2%
set TSHour=%Time:~0,2%
set TSMinutes=%Time:~3,2%
set Timestamp=

if "%TSHour:~0,1%" == " " set TSHour=0%TSHour:~1,1%
if "%TSMinutes:~0,1%" == " " set TSMinutes=0%TSMinutes:~1,1%

:: Before running the Unreal Automation Tool, we need to make sure that we have the latest revision of the git repo
call Magnus_SourceRepo_GetLatest.bat

:: [Required Python Verison: 3.5] After getting the latest revision of the current branch, we need to run the pre-build events
call python Prebuild\Magnus_PrebuildEvents.py

:: Push the current working directory onto the stack so that we can retrieve information about the revision
PUSHD %LocalRepoPath%

:: Copy the short version of Git tag
for /f %%i in ('git rev-parse --short HEAD') do set CurrentCommitShortTag=%%i

:: Get current branch name
for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set CurrentBranchName=%%i
set CurrentBranchName=%CurrentBranchName:feature_=f_%

set Timestamp=%TSMonth%.%TSDay%.%TSHour%.%TSMinutes%
set OutputFolderName=%BuildName%.%CurrentBranchName%-%Timestamp%-%CurrentCommitShortTag%

POPD

:: Run the Unreal Automation Tool to create a Shipping Build for the Client and Server

call %UATPath% BuildCookRun -project=%UProjectPath% -noP4 -clientconfig=%ClientBuildType% -nocompile -utf8output -platform=Win64+WindowsClient -targetplatform=Win64 -build -cook -map=StartLevel+TransitionLevel+JustinsWorld -unversionedcookedcontent -pak -compressed -stage -package -CrashReporter -cmdline= -Messaging -nokill

if %ERRORLEVEL% NEQ 0  (
	echo Magnus Development Client Build Failed
	pause
	exit /b 1
)

call %UATPath% BuildCookRun -project=%UProjectPath% -noP4 -clientconfig=%ClientBuildType% -serverconfig=%ServerBuildType% -nocompile -utf8output -platform=Win64 -server -serverplatform=Win64 -targetplatform=Win64 -build -cook -map=StartLevel+TransitionLevel+JustinsWorld -unversionedcookedcontent -pak -compressed -stage -package -CrashReporter -cmdline= -Messaging -nokill

if %ERRORLEVEL% NEQ 0  (
	echo Magnus Development Server Build Failed
	pause
	exit /b 1
)


::call %UATPATH% BuildCookRun -project=%UProjectPath% -noP4 -clientconfig=%ClientBuildType% -serverconfig=%ServerBuildType% -nocompile -nocompileeditor -utf8output -platform=%Platform% -nodebuginfo -server -serverplatform=%Platform% -targetplatform=%Platform% -build -cook -map=JustinsWorld+StartLevel+TransitionLevel -pak -compressed -stage -cmdline= -Messaging -nokill

::call %UATPATH% BuildCookRun -project=%UProjectPath% -noP4 -clientconfig=%ClientBuildType% -serverconfig=%ServerBuildType% -nocompile -nocompileeditor -utf8output -platform=%Platform% -server -serverplatform=%Platform% -targetplatform=%Platform% -build -cook -map=JustinsWorld+StartLevel+TransitionLevel -pak -nodebuginfo -createreleaseversion=MagnusServer-0.0.1 -compressed -stage

:: [OLD] call %UATPATH% BuildCookRun -nodebuginfo -nop4 -project=%UProjectPath% -cook -stage -package -map=StartLevel+TransitionLevel+JustinsWorld -serverconfig=%ServerBuildType% -pak -targetplatform=Win64 -build -utf8output -cmdline= -Messaging -nokill

::if %ERRORLEVEL% NEQ 0  (
::	echo Magnus Shipping Server Build Failed
::	pause
::	exit /b 1
::)

::call %UATPATH% BuildCookRun -project=%UProjectPath% -noP4 -clientconfig=%ClientBuildType% -serverconfig=%ServerBuildType% -nocompile -nocompileeditor -utf8output -platform=WindowsClient+Win64 -targetplatform=%Platform% -cook -map=JustinsWorld+StartLevel+TransitionLevel -stage -pak -nodebuginfo -prereqs -createreleaseversion=MagnusClient-0.0.1 -compressed -stage -package -cmdline= -Messaging -cmdline= -Messaging -nokill


:: [OLD] call %UATPATH% BuildCookRun -nodebuginfo -nop4 -project=%UProjectPath% -cook -stage -package -map=StartLevel+TransitionLevel+JustinsWorld -clientconfig=%ClientBuildType% -serverconfig=%ServerBuildType% -pak -prereqs -targetplatform=Win64 -build -utf8output -cmdline= -Messaging -nokill

::if %ERRORLEVEL% NEQ 0  (
::	echo Magnus Shipping Client Build Failed
::	pause
::	exit /b 1
::)

:: Make sure we have the latest revision of the repo
cd %P4RepoRootPath%

p4 sync

:: To archive the Development Build, we need to move the Development Builds to a new folder to push to Perforce repo

:: Make new folder to contain new build files
mkdir %P4RepoPath%%OutputFolderName%

:: Moving Client and Server Build files
xcopy /S /R %DeployedBuildsPath% %P4RepoPath%%OutputFolderName%

:: Submit the new files to Perforce repo
cd %P4RepoPath%%OutputFolderName%

p4 reconcile -a

p4 submit -d "Pushing %OutputFolderName% Build"

echo Build Successful!

endlocal

:end
pause