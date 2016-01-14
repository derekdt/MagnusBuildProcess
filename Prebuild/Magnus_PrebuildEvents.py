#Python script that runs all the pre-build events that are necessary

import configparser
import subprocess
import sys
import os

if __name__ == "__main__":
    currentPrebuildEventID = 1;
    preBuildEventsConfigParser = configparser.ConfigParser()
    print("Running Prebuild Events!\n")
    preBuildEventsConfigParser.read(sys.path[0] + "\\" + "BuildEventsConfig.ini")

    for buildEventKey in preBuildEventsConfigParser['PrebuildEvents']:
        currentBuildEventScript = preBuildEventsConfigParser['PrebuildEvents'][buildEventKey]
        
        print(("[{0}] " + buildEventKey + " => " + currentBuildEventScript).format(currentPrebuildEventID))

        print("---------------------------------------------------------------\n");
        
        # Run the current pre-build script
        scriptProcess = subprocess.Popen(["python", sys.path[0] + "\\" + currentBuildEventScript], shell=True)

        # Wait for completion
        scriptProcess.communicate()

        print("Completed " + buildEventKey + " pre-build event!\n")

        print("---------------------------------------------------------------\n");

        currentPrebuildEventID += 1
        
    



