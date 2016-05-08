# Regenerates project files incase that recent commits require files to be added

import configparser
import subprocess
import sys
import os

if __name__ == "__main__":
	print("Running ProjectGeneration")

	commonConfigParser = configparser.ConfigParser()
	commonConfigParser.read(sys.path[0] + os.sep + ".." + os.sep + "CommonConfig.ini")

	projectInfoSection = commonConfigParser['ProjectInfo']
	engineInfoSection = commonConfigParser['EngineInfo']

	projectFilePath = projectInfoSection['ProjectRootPath'] + os.sep + projectInfoSection['ProjectName'] + ".uproject"

	print("Project File Path: " + projectFilePath)

	projectFileRegenProcess = subprocess.Popen([sys.path[0] + os.sep + "Magnus_ProjectGeneration.bat",engineInfoSection['BuildToolPath'],projectFilePath], shell=True)
	
	projectFileRegenProcess.communicate()
	
	
	
