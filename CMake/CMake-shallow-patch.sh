#! /bin/bash

set -e

if [ -z "${1}" ]; then 
    SEARCH_PATH="/usr"
    echo "Searching in $SEARCH_PATH"
else 
    SEARCH_PATH=${1}
    echo "Searching in $SEARCH_PATH"
fi

# Find the file. Typically its under /usr
TARGET_FILE=$(find $SEARCH_PATH -name ExternalProject.cmake)
echo $TARGET_FILE

# Make backup copy of it
cp $TARGET_FILE "${TARGET_FILE}.backup"
