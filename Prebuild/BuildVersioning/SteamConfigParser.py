# Provides functionality to parse the custom .ini UE4 Engine for Steam versioning
import re


def RetrieveCurrentSteamVersion(ConfigFilePath,SectionName,OptionName):
    # Parse through all lines of the config file and look for the line that has
    # the string "[OnlineSubsystemSteam]"
    configFileStream = open(ConfigFilePath,'r')
    sectionNameString = "[" + SectionName + "]"
    optionValueString = ""
    bReachedSection = False
    optionRegexString = OptionName + "=(.*)"
	
    for currentLine in configFileStream.readlines():
        currentLine = currentLine.strip('\n')
        
        if not bReachedSection:
            if currentLine == sectionNameString:
                print("Found section name line: " + currentLine.strip('\n'))
                bReachedSection = True
        else:
            optionRegexSearch = re.search(optionRegexString,currentLine)

            if optionRegexSearch:
                optionValueString = optionRegexSearch.group(1)
                break;

    print "Option Value: ", optionValueString

    return optionValueString

def UpdateSteamVersion(ConfigFilePath, SectionName, OptionName, NewSteamVersionString):
    # Validate that input version string is of the correct format
    sectionNameString = "[" + SectionName + "]"
    optionRegexString = "(" + OptionName + ")" + "=(.*)"
    
    # Valid version string
    configFileStream = open(ConfigFilePath, 'r')
    configFileData = configFileStream.readlines()
    configFileStream = open(ConfigFilePath, 'w')
    bReachedSection = False
        
    for currentLine in configFileData:
        strippedLine = currentLine.strip('\n')
        
        if not bReachedSection:
            configFileStream.write(currentLine)
            if strippedLine == sectionNameString:
                print("Found section!")
                bReachedSection = True
        else:
            optionRegexSearch = re.search(optionRegexString,strippedLine)

            if optionRegexSearch:
                currentLine = "%s=%s\n" % (optionRegexSearch.group(1),NewSteamVersionString)
                print("Updated Version: " + currentLine)
                configFileStream.write(currentLine)
            else:
                configFileStream.write(currentLine)
        
if __name__ == "__main__":
    UpdateSteamVersion("DefaultEngine.ini","OnlineSubsystemSteam","GameVersion", "0.5.0-Derek Truong")
    #RetrieveCurrentSteamVersion("DefaultEngine.ini","OnlineSubsystemSteam","GameVersion")    
