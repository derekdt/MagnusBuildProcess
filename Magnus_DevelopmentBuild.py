# Development Build script for Magnus

import subprocess
import configparser
import Config.ConfigManager

if __name__ == "__main__":
    print("Starting Development build for Magnus")
    
    automationalToolCallString = GConfigManager().GetConfigValueFromSection("EngineConfig","UnrealAutomationPath")
    
    # Start the pre-build events
    preBuildProcess = subprocess.Popen("Prebuild\Magnus_PrebuildEvents.py", shell=True)
    preBuildProcess.communicate()
    
    # Run Unreal Engine's Automation Tool
    

    # Start the post-build events
