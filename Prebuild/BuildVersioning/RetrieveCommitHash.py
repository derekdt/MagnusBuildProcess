import configparser
import sys
import subprocess
import os

if __name__ == "__main__":
    commonConfigFilePath = sys.path[0] + os.sep + ".." + os.sep + "CommonConfig.ini"
    commonConfigParser = configparser.ConfigParser()
    
    print("Common Config Path:",commonConfigFilePath)
    
    commonConfigParser.read(commonConfigFilePath)
    
    # Retrieve the path to the project repo
    projectRepoPath = commonConfigParser['ProjectInfo']['ProjectRootPath']
    
    print("Project Repo Path:",projectRepoPath)
    
    # Construct the shell command
    
    # Change directories to the project repo
    finalShellCommand = "cd "
    
    finalShellCommand += "\""
    
    finalShellCommand += projectRepoPath
    
    finalShellCommand += "\""
    
    finalShellCommand += " && "
    
    # git rev-parse HEAD command
    
    finalShellCommand += "git rev-parse HEAD"
    
    print("Final Shell Command:",finalShellCommand)
    
    shellCommandOutput = subprocess.check_output(finalShellCommand,shell=True)
    
    shellCommandOutputString = shellCommandOutput.decode("utf-8")
    
    print(shellCommandOutputString)
