# Post-build script that migrations necessary Steam .dll files to the root directory
import configparser
import os
import shutil
import sys

if __name__ == "__main__":
    print("Running Steam DLL migration post build script")

    # Retrieve the staged build from the project folder and migrate the steam DLL files
    commonConfigParser = configparser.ConfigParser()
    commonConfigParser.read(sys.path[0] + "\\..\CommonConfig.ini")

    buildDeploymentPath = commonConfigParser["ProjectConfig"]["BuildDeploymentPath"]
    steamRelativePath = commonConfigParser["ProjectConfig"]["SteamRelativePath"]
    finalDLLPath = buildDeploymentPath + "\\" + steamRelativePath

    buildRelativePath = commonConfigParser["ProjectConfig"]["RootRelativePath"]
    buildAbsolutePath = buildDeploymentPath + "\\" + buildRelativePath
    
    print("Final DLL Directory Path: " + finalDLLPath)
    print("Final Build Directory Path: " + buildAbsolutePath)
    
    dllFileNames = os.listdir(finalDLLPath)
    
    for currentDLLFile in dllFileNames:
        print("Moving " + currentDLLFile + " to " + buildAbsolutePath)
        shutil.copy(finalDLLPath + "\\" + currentDLLFile,buildAbsolutePath)
    
    

    
    
