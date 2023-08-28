#! /bin/bash

# Check if run with root
if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi


# Search in /usr by default, if no path provided
if [ -z "${1}" ]; then 
    SEARCH_PATH="/usr"
    echo "Searching in $SEARCH_PATH"
else 
    SEARCH_PATH=${1}
    echo "Searching in $SEARCH_PATH"
fi

# Find the file. Typically its under /usr
TARGET_FILE=$(find $SEARCH_PATH -name ExternalProject.cmake)
echo "Found $TARGET_FILE"

# Make backup copy of it
echo "Making backup $TARGET_FILE.backup"
cp $TARGET_FILE "${TARGET_FILE}.backup"

# Find and replace line
echo "Patching $TARGET_FILE"
sed -i 's/--no-single-branch/--shallow-submodules --single-branch/g' $TARGET_FILE

# Verify
echo "Verify patch"
grep "\-\-shallow-submodules \-\-single-branch" $TARGET_FILE
retVal=$?
if [ $retVal -ne 0 ]; then
    echo "Patch failed. Reverting changes..."
    # Restore backup file
    rm $TARGET_FILE
    mv $TARGET_FILE.backup $TARGET_FILE
    exit $retVal
fi

echo "Patch completed"
exit $retVal