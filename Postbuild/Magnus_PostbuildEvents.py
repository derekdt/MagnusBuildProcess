#Python script that runs all the pre-build events that are necessary

import configparser
import subprocess
import sys
import os

if __name__ == "__main__":
    currentPostbuildEventID = 1;
    postBuildEventsConfigParser = configparser.ConfigParser()
    print("Running Postbuild Events!\n")
    postBuildEventsConfigParser.read(sys.path[0] + "\\" + "BuildEventsConfig.ini")

    print(sys.path[0])
    
    for buildEventKey in postBuildEventsConfigParser['PostbuildEvents']:
        currentBuildEventScript = postBuildEventsConfigParser['PostbuildEvents'][buildEventKey]
        
        print(("[{0}] " + buildEventKey + " => " + currentBuildEventScript).format(currentPostbuildEventID))

        print("---------------------------------------------------------------\n");
        
        # Run the current post-build script
        scriptProcess = subprocess.Popen(["python", sys.path[0] + "\\" + currentBuildEventScript], shell=True)

        # Wait for completion
        scriptProcess.communicate()

        print("Completed " + buildEventKey + " post-build event!")

        print("---------------------------------------------------------------\n");

        currentPostbuildEventID += 1
        
    



