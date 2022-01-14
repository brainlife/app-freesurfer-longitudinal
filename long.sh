#!/bin/bash

set -e
set -x

echo "running longitudinal processing"

freesurfer=`jq -r .freesurfer config.json`
template=`jq -r .template config.json`

#export OMP_NUM_THREADS=8

rm -rf subjects
mkdir -p subjects

ln -s ../$freesurfer subjects/input
ln -s ../$template subjects/template

export SUBJECTS_DIR=`pwd`/subjects
cd $SUBJECTS_DIR
recon-all -long input template -all
