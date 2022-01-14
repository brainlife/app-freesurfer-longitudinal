#!/bin/bash

export OMP_NUM_THREADS=16

rm -rf subjects
mkdir -p subjects

set -e
set -x

#TODO - I can't use random index (like 0,1,2) to fake subject name. -long will look for the right id
#so I need to find the data object ID and use that as subject name

#construct recon-all commandline"
cmd=`python << END
cmd="-base template"
import os
import sys
import json
import hashlib
with open("config.json") as f:
    config = json.load(f)

md5hash = hashlib.md5() 
for i,f in enumerate(config["freesurfers"]):
    #compute md5sum of norm.mgz to be used as tp name
    with open(f+"/mri/norm.mgz") as fnorm:
        norm = fnorm.read()
        md5hash.update(norm)
        digest = md5hash.hexdigest()
    os.symlink("../"+f, "subjects/"+digest)
    cmd+= " -tp "+digest
print(cmd)
END
`

export SUBJECTS_DIR=`pwd`/subjects
cd subjects
recon-all $cmd -all

mkdir output
#map subject/template as output in brainlife
ln -s subject/template output/output

cat > product.json <<EOF
{
    "meta":{
        "longitudinal": true
    },
}
EOF

