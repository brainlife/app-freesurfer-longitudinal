#!/bin/bash

set -e
set -x

echo "running longitudinal processing"

template=`jq -r .template config.json`
freesurfer=`jq -r .freesurfer config.json`

rm -rf subjects
mkdir -p subjects

md5sum=$(md5sum $freesurfer/mri/norm.mgz | awk '{print $1}')
ln -s ../$freesurfer subjects/$md5sum
ln -s ../$template subjects/template

export SUBJECTS_DIR=`pwd`/subjects
cd $SUBJECTS_DIR
recon-all -long $md5sum template

mkdir output
ln -s subject/$mdsum.long.template 

#TODO
#cat > product.json <<EOF
#{
#}
#EOF

