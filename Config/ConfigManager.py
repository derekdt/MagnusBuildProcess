# Config Manager - Gets initialized everything a build is trying to be made. For convenience uses.

import configparser
import sys
import os

class GConfigManager(object):
    class __GConfigManager:
        def __init__(self):
            self.m_SectionDictionary = {}

            self.m_ConfigPath = os.path.join(os.path.dirname(__file__),"CommonConfig.ini")

            print("Config Path: " + self.m_ConfigPath)

            # Initialize the section dictionary by parsing the CommonConfig file
            configParser = configparser.ConfigParser()

            configParser.read(self.m_ConfigPath)

            for configSection in configParser.sections():
                self.m_SectionDictionary[configSection] = configParser[configSection]
    m_ConfigManagerInstance = None

    def __init__(self):
        if not GConfigManager.m_ConfigManagerInstance:
            GConfigManager.m_ConfigManagerInstance = GConfigManager.__GConfigManager()

    def GetConfigValueFromSection(self,sectionName,keyName):
        return GConfigManager.m_ConfigManagerInstance.m_SectionDictionary[sectionName][keyName]

