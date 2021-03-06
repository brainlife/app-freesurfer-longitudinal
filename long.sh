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
#ln -s ../$template subjects/template
cp -r $template subjects/template

#copy the base
#ln -s ../$freesurfer subjects/$md5sum
cp -r $freesurfer subjects/$md5sum

#copy timepoint inputs
for dir in $(ls $timepoints); do
    if [ "$dir" != "$md5sum" ]; then
        #ln -s $(realpath $timepoints/$dir) subjects/$dir
        cp -r $timepoints/$dir subjects/$dir
    fi
done

#make sure recon-all can write stuff to subjects directory
#(not sure why it does that.. but it does)
chmod -R +w subjects

(
export SUBJECTS_DIR=`pwd`/subjects #do I really need pwd?
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

