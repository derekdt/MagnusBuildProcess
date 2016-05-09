# Versions the current build that is running so that we can have distinguished build IDs

import configparser
import sys
import re

if __name__ == "__main__":
    print("Running BuildVersioning\n")

    # sys.path[0] represents the current path that the script is running in
    commonConfigFilePath = sys.path[0] + "\\" + "..\CommonConfig.ini"
    versioningConfigFilePath = sys.path[0] + "\BuildVersioningConfig.ini"

    commonConfigParser = configparser.ConfigParser()
    versioningConfigParser = configparser.ConfigParser()
    buildConfigParser = configparser.ConfigParser()

    commonConfigParser.read(commonConfigFilePath)
    versioningConfigParser.read(versioningConfigFilePath)

    #Grab the ini file within the Config folder of the project

    projectRootPath = commonConfigParser['ProjectInfo']['ProjectRootPath']

    versioningConfigRelativePath = versioningConfigParser['VersioningInfo']['VersionConfigRelativePath']

    finalVersioningConfigPath = projectRootPath + '\\' + versioningConfigRelativePath

    buildConfigParser.read(finalVersioningConfigPath)

    print("Full Project Version Config File Path: " + finalVersioningConfigPath)

    # Grab the Project Version from the Build Config file

    oldProjectVersion = buildConfigParser['/Script/EngineSettings.GeneralProjectSettings']['ProjectVersion']

    # Extract the current build number(Format: x.x.x-BuildID)

    buildIDRegexSearch = re.search("(\d+)\.(\d+)\.(\d+)-(\d+)",oldProjectVersion)

    if buildIDRegexSearch:    
        newBuildVersionStr = str(int(commonConfigParser['ProjectInfo']['BuildVersionID']) + 1)

        commonConfigParser['ProjectInfo']['BuildVersionID'] = newBuildVersionStr

        newProjectVersion = "%s.%s.%s-%s" % (buildIDRegexSearch.group(1),buildIDRegexSearch.group(2),buildIDRegexSearch.group(3),newBuildVersionStr)

        print("New Project Version: " + newProjectVersion)

        print("New Build Version: " + newBuildVersionStr + "\n")
        
        buildConfigParser['/Script/EngineSettings.GeneralProjectSettings']['ProjectVersion'] = newProjectVersion

        # Save back the versioning config file in project directory
        with open(finalVersioningConfigPath, 'w+') as configFile:
            buildConfigParser.write(configFile)

        # Save back the common config file
        with open(commonConfigFilePath, 'w+') as configFile:
            commonConfigParser.write(configFile)
    else:
        print("Error: Build Version format is incorrect!")
