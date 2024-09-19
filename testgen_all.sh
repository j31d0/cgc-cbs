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
		    pushd poller/for-release > /dev/null
		    PYTHONPATH=$PYTHONPATH:$SCRIPTDIR/tools/cb-testing/lib $SCRIPTDIR/tools/poll-generator/generate-polls machine.py state-graph.yaml . --count 50 1>/dev/null 2>/dev/null
		    popd > /dev/null
	    fi
	    popd > /dev/null
            if [ ! -f "$entry/poller/for-release/GEN_00000_00049.xml" ]; then
                    rm -r $entry
		    echo "$VNAME: testgen failed"
            fi
        fi
    done
else
    echo "Directory '$base_dir' not found."
fi

