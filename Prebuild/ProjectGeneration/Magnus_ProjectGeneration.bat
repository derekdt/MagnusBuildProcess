@echo off

:: Parameters of batch script:
:: 1. Path to the Unreal Build Tool
:: 2. Path to Unreal project file

if [%1] NEQ []  (
	if [%2] NEQ [] (
		%1 -projectfiles -project="%2" -game -engine -progress
	)
)

:: C:/Jenkins/Magnus/Engines/4.9/UnrealEngine/Engine/Binaries/DotNET/UnrealBuildTool.exe  -projectfiles -project="C:/Users/SillyLandmine/Desktop/Dev_Repo/DR2015/NubbleSpaceProgram/NubbleSpaceProgram.uproject" -game -engine -progress
