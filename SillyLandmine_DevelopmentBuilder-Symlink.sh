#!/bin/bash

# Magnus Development Builder for Mac Platform
# Project Information =============================
readonly ProjectName=NubbleSpaceProgram
readonly LocalRepoPath="/Users/SillyLandmine/Desktop/Magnus/$ProjectName"
readonly UProjectPath="$LocalRepoPath/$ProjectName.uproject"

# UE4 Information
readonly EngineLinkPath="/Users/SillyLandmine/Desktop/EngineLink"
# readonly UATPath=UnrealEngine/Engine/Build/BatchFiles
readonly UATPath=Engine/Build/BatchFiles
readonly AutomationScript=RunUAT.command
readonly DeployedBuildsPath="$LocalRepoPath/Saved/StagedBuilds"

# Platform Information ============================
readonly ClientBuildType=Development
readonly ServerBuildType=Development
readonly Platform=Win64
readonly BuildName=Dev-PC

# Version Control Information =====================
readonly P4RepoPath="/Users/SillyLandmine/Perforce/Magnus_MacBuilds"
readonly P4RepoRootPath="/Users/SillyLandmine/Perforce/Magnus_MacBuilds"

# Before running the Unreal Automation Tool, we need to make sure that we have the latest revision of the git repo
sh ./SillyLandmine_SourceRepo_GetLatest.sh

# [Required Python Verison: 3.5] After getting the latest revision of the current branch, we need to run the pre-build events
python3 ./Prebuild/Magnus_PrebuildEvents.py

# Push the current working directory onto the stack so that we can retrieve information about the revision
pushd $LocalRepoPath > /dev/null

# Copy the short version of Git tag
CurrentCommitShortHash=$(git rev-parse --short HEAD)

# Get current branch name
CurrentBranchName=$(git rev-parse --abbrev-ref HEAD)

CurrentBranchName="${CurrentBranchName/feature_/f_}"

readonly Timestamp=$(date +'%m.%d.%I.%M')
readonly OutputFolderName=$BuildName.$CurrentBranchName-$Timestamp-$CurrentCommitShortHash

popd > /dev/null

# Follow the symlink to the target engine folder
pushd $EngineLinkPath > /dev/null

cd $UATPath

# Run the Unreal Automation Tool to create a Development Build for only the Client because we can just host Windows versions of the Server

sh $AutomationScript BuildCookRun -project=$UProjectPath -noP4 -clientconfig=$ClientBuildType -serverconfig=$ServerBuildType -nocompile -nocompileeditor -installed -utf8output -platform=Mac+Mac -targetplatform=Mac -build -cook -map=JustinsWorld+StartLevel+TransitionLevel -unversionedcookedcontent -stage -pak -compressed

if [ $? -ne 0 ]
then
	echo "============[ UNSUCCESSFUL ] Magnus Mac Development Client Build Failed"
	read -n1 -r -p "Press any key to continue..."
	exit 1
fi

echo "============[ SUCCESS ] Built the Client Build"

sh $AutomationScript BuildCookRun -project=$UProjectPath -noP4 -clientconfig=$ClientBuildType -serverconfig=$ServerBuildType -nocompile -nocompileeditor -installed -utf8output -platform=Mac+Mac -server -serverplatform=Mac -targetplatform=Mac -build -cook -map=JustinsWorld+StartLevel+TransitionLevel -unversionedcookedcontent -stage -pak -compressed

if [ $? -ne 0 ]
then
	echo "============[ UNSUCCESSFUL ] Magnus Mac Development Server Build Failed"
	read -n1 -r -p "Press any key to continue..."
	exit 1
fi

echo "============[ SUCCESS ] Built the Server Build"

echo "============[ SUCCESS ] Client and Server Finished Building"

popd > /dev/null

# Make sure we have the latest revision of the repo
cd $P4RepoRootPath

p4 sync

# To archive the Development Build, we need to move the Development Builds to a new folder to push to Perforce repo

# Make new folder to contain new build files
mkdir $P4RepoPath/$OutputFolderName

# Moving Client and Server Build files
cp -rv $DeployedBuildsPath $P4RepoPath/$OutputFolderName

# Submit the new files to Perforce repo
cd $P4RepoPath/$OutputFolderName

p4 reconcile -a

p4 submit -d $(printf "Pushing %s Build" "$OutputFolderName")