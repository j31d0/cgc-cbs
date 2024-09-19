#!/bin/bash

SCRIPTDIR=$(pwd)
echo $SCRIPTDIR
base_dir="final-passed-challenges"
if [ -d "$base_dir" ]; then
    # Iterate over each item in the directory
    for entry in "$base_dir"/*; do
	if [ -d "$entry" ]; then
            # Echo the directory name
	    pushd $entry > /dev/null
	    VNAME="$(basename $entry)"
	    if [ -d "poller/for-release" ]; then
		    PATH=$PATH:$SCRIPTDIR/bin:$SCRIPTDIR/tools/cb-testing:$SCRIPTDIR/tools/service-launcher:$SCRIPTDIR/tools/poll-generator PYTHONPATH=$PYTHONPATH:$SCRIPTDIR/tools/cb-testing/lib $SCRIPTDIR/tools/cb-testing/cb-test --directory . --cb $VNAME --xml_dir poller/for-release/ 1>/dev/null 2>/dev/null
		    RESULT=$?
	    fi
	    popd > /dev/null
	    if [ ! "$RESULT" -eq "0" ]; then
                    rm -r $entry
                    echo "$VNAME: testcheck failed"
	    fi
        fi
    done
else
    echo "Directory '$base_dir' not found."
fi

