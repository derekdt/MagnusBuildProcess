# Shell Script to retrieve the latest version on the local source repo of the project
readonly LocalRepoPath="/Users/SillyLandmine/Desktop/Magnus/NubbleSpaceProgram"

# Push the current directory path onto a stack and change the current directory path to $LocalRepoPath
pushd $LocalRepoPath > /dev/null

git fetch origin

if [ $? -ne 0 ]
then
	echo $(printf '============[ UNSUCCESSFUL ] Error %d during git fetch origin command' $?)
	exit 1
fi

echo "============[ SUCCESS ] Fetch Origin"

echo "============[ SUCCESS ] Removing Local Changes from Config"

git checkout ./Config

echo "============[ SUCCESS ] Pulling Latest Revision"

git pull

if [ $? -ne 0 ]
then
	echo $(printf '============[ UNSUCCESSFUL ] Error %d during git pull command' $?)
	exit 1
fi

echo "============[ SUCCESS ] Pull Successful"

popd > /dev/null