# Versions the current build that is running so that we can have distinguished build IDs

import configparser
import sys
import re
import subprocess
import SteamConfigParser
import os

def RetrieveLongCommitHash(ProjectRepoPath):
 
    # Construct the command to retrieve the commit hash
    finalShellCommand = "cd "
    
    finalShellCommand += "\""
    
    finalShellCommand += ProjectRepoPath
    
    finalShellCommand += "\""
    
    finalShellCommand += " && "
    
    # git rev-parse HEAD command
    
    finalShellCommand += "git rev-parse HEAD"

    shellCommandOutput = subprocess.check_output(finalShellCommand,shell=True)
    
    shellCommandOutputString = shellCommandOutput.decode("utf-8")
    
    shellCommandOutputString = shellCommandOutputString.replace("\n","")
    
    return shellCommandOutputString

if __name__ == "__main__":
    print("Running BuildVersioning\n")

    # sys.path[0] represents the current path that the script is running in
    commonConfigFilePath = sys.path[0] + os.sep + ".." + os.sep + "CommonConfig.ini"
    versioningConfigFilePath = sys.path[0] + os.sep + "BuildVersioningConfig.ini"

    # commonConfigParser and versiosningConfigParser are used to determine the build ID and relative paths of config files in project directory
    commonConfigParser = configparser.ConfigParser()
    versioningConfigParser = configparser.ConfigParser()
    
    # buildConfigParser and steamConfigParser are used to read and edit the individual versiong strings in the config file
    buildConfigParser = configparser.ConfigParser()
    
    commonConfigParser.read(commonConfigFilePath)
    versioningConfigParser.read(versioningConfigFilePath)

    #Grab the ini file within the Config folder of the project

    projectRootPath = commonConfigParser['ProjectInfo']['ProjectRootPath']

    versioningConfigRelativePath = versioningConfigParser['VersioningInfo']['VersionConfigRelativePath']
    steamVersioningConfigRelativePath = versioningConfigParser['VersioningInfo']['SteamVersionConfigRelativePath']
    
    finalVersioningConfigPath = projectRootPath + os.sep + versioningConfigRelativePath
    finalSteamVersioningConfigPath = projectRootPath + os.sep + steamVersioningConfigRelativePath
    
    print("Full Project Version Config File Path: " + finalVersioningConfigPath)
    print("Full Steam Version Config Path: " + finalSteamVersioningConfigPath)
    
    buildConfigParser.read(finalVersioningConfigPath)
    
    # Grab the Project Version from the Build Config file

    oldProjectVersionString = buildConfigParser['/Script/EngineSettings.GeneralProjectSettings']['ProjectVersion']
    oldSteamVersionString = SteamConfigParser.RetrieveCurrentSteamVersion(finalSteamVersioningConfigPath,"OnlineSubsystemSteam","GameVersion")

    # Extract the current build number(Format: x.x.x-CommitHash)
    buildIDRegexSearch = re.search("(\d+)\.(\d+)\.(\d+)-([a-zA-Z0-9]+)",oldProjectVersionString)
    steamIDRegexSearch = re.search("(\d+)\.(\d+)\.(\d+)-([a-zA-Z0-9]+)",oldSteamVersionString)
    
    if buildIDRegexSearch and steamIDRegexSearch: 
        # Get the commit hash of the HEAD of the repo
        currentLongCommitHash = RetrieveLongCommitHash(commonConfigParser['ProjectInfo']['ProjectRootPath'])
        
        commonConfigParser['ProjectInfo']['BuildVersionID'] = currentLongCommitHash

        newProjectVersionString = "%s.%s.%s-%s" % (buildIDRegexSearch.group(1),buildIDRegexSearch.group(2),buildIDRegexSearch.group(3),currentLongCommitHash)
        newSteamVersionString = "%s.%s.%s-%s" % (steamIDRegexSearch.group(1),steamIDRegexSearch.group(2),steamIDRegexSearch.group(3),currentLongCommitHash)
        
        print()
        print("\t(+) New Project Version String: " + newProjectVersionString)
        print("\t(+) New Steam Version String: " + newSteamVersionString)
        print()
        
        buildConfigParser['/Script/EngineSettings.GeneralProjectSettings']['ProjectVersion'] = newProjectVersionString
        SteamConfigParser.UpdateSteamVersion(finalSteamVersioningConfigPath,"OnlineSubsystemSteam","GameVersion",newSteamVersionString)
        
        # Save back the versioning config file in project directory
        with open(finalVersioningConfigPath, 'w+') as configFile:
            buildConfigParser.write(configFile)

        # Save back the common config file
        with open(commonConfigFilePath, 'w+') as configFile:
            commonConfigParser.write(configFile)
    else:
        print("Error: Build Version or Steam Version format is incorrect!")
