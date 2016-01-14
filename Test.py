from Config.ConfigManager import GConfigManager

if __name__ == "__main__":
    print(GConfigManager().GetConfigValueFromSection("EngineConfig","UnrealAutomationPath")
)
