#!/bin/bash

set -e
set -x

echo "running longitudinal processing"

freesurfer=`jq -r .freesurfer config.json`
template=`jq -r .template config.json`
timepoints=`jq -r .timepoints config.json`

#construct subject directory to process in 
rm -rf subjects
mkdir -p subjects
md5sum=$(md5sum $freesurfer/mri/norm.mgz | awk '{print $1}')
ln -s ../$template subjects/template
ln -s ../$freesurfer subjects/$md5sum
for dir in $(ls $timepoints); do
    if [ "$dir" != "$md5sum" ]; then
        ln -s $(realpath $timepoints/$dir) subjects/$dir
    fi
done

(
export SUBJECTS_DIR=`pwd`/subjects
cd $SUBJECTS_DIR
recon-all -long $md5sum template -all
)

mkdir output
ln -s ../subjects/$md5sum.long.template output/output

#TODO
#cat > product.json <<EOF
#{
#}
#EOF

