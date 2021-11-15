#!/bin/bash

set -e
set -x

echo "running longitudinal processing"

freesurfer=`jq -r .freesurfer config.json`
template=`jq -r .template config.json`

export OMP_NUM_THREADS=8
export SUBJECTS_DIR=`pwd`
recon-all -long $freesurfer $template -all
