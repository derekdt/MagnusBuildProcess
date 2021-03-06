@echo off

setlocal EnableDelayedExpansion
set ProjectName=NubbleSpaceProgram
set LocalRepoPath="C:\Users\SillyLandmine\Desktop\Dev_Repo\DR2015\%ProjectName%"
set UATPath="C:\Jenkins\Magnus\Engines\4.9\UnrealEngine\Engine\Build\BatchFiles\RunUAT"
set UProjectPath="C:\Users\SillyLandmine\Desktop\Dev_Repo\DR2015\%ProjectName%\%ProjectName%.uproject"
set P4RepoPath="C:\Users\SillyLandmine\Perforce\Magnus\gamepipe\AGP2015\ADatingSim\"
set P4RepoRootPath="C:\Users\SillyLandmine\Perforce\Magnus"
set DeployedBuildsPath="C:\Users\SillyLandmine\Desktop\Dev_Repo\DR2015\%ProjectName%\Saved\StagedBuilds"
set ClientBuildType=Development
set ServerBuildType=Development
set Platform=Win64
set BuildName=Dev-PC
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
pushd %LocalRepoPath%

:: Copy the short version of Git tag
for /f %%i in ('git rev-parse --short HEAD') do set CurrentCommitShortTag=%%i

:: Get current branch name
for /f %%i in ('git rev-parse --abbrev-ref HEAD') do set CurrentBranchName=%%i
set CurrentBranchName=%CurrentBranchName:feature_=f_%

set Timestamp=%TSMonth%.%TSDay%.%TSHour%.%TSMinutes%
set OutputFolderName=%BuildName%.%CurrentBranchName%-%Timestamp%-%CurrentCommitShortTag%

popd

:: Run the Unreal Automation Tool to create a Development Build for the Client and Server

::A5CE91AB425118306EAC04A2DC9502A5

call %UATPATH% BuildCookRun -project=%UProjectPath% -noP4 -clientconfig=%ClientBuildType% -nocompile -utf8output -platform=Win64+WindowsClient -targetplatform=Win64 -build -cook -map=StartLevel+TransitionLevel+JustinsWorld -unversionedcookedcontent -pak -compressed -stage -package -CrashReporter -cmdline= -Messaging -nokill

if %ERRORLEVEL% NEQ 0  (
	echo Magnus Development Client Build Failed
	pause
	exit /b 1
)

call %UATPATH% BuildCookRun -project=%UProjectPath% -noP4 -clientconfig=%ClientBuildType% -serverconfig=%ServerBuildType% -nocompile -utf8output -platform=Win64 -server -serverplatform=Win64 -targetplatform=Win64 -build -cook -map=StartLevel+TransitionLevel+JustinsWorld -unversionedcookedcontent -pak -compressed -stage -package -CrashReporter -cmdline= -Messaging -nokill

if %ERRORLEVEL% NEQ 0  (
	echo Magnus Development Server Build Failed
	pause
	exit /b 1
)

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

endlocal

:end
pause