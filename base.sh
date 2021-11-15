#!/bin/bash

set -e
set -x

freesurfers=`jq -r .freesurfers config.json`

cmd=`python << END
cmd="-base template"
import os
import sys
import json
with open("config.json") as f:
    config = json.load(f)
for f in config["freesurfers"]:

    #we are constructing command line argument! let's validate the user input
    if os.path.isdir(f):
        cmd+= " -tp "+f
    else:
        print("directory doesn't exist:"+f)
        sys.exit(1)
print(cmd)
END
`

export OMP_NUM_THREADS=8
export SUBJECTS_DIR=`pwd`
recon-all $cmd
