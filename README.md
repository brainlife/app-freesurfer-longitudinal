# app-freesurfer-longitudinal

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Builds a FreeSurfer 7.1.1 longitudinal base (within-subject template) from several cross-sectional FreeSurfer outputs of the same subject with recon-all -base; step 1 of 2 of longitudinal processing.**

Runs recon-all -base -all over all input FreeSurfer outputs (timepoints named by the md5 of their norm.mgz) to create an unbiased within-subject template. Use it before Step 2/2, which runs recon-all -long for each timepoint against this template. All inputs must be cross-sectional FreeSurfer runs of the same subject; requires a FreeSurfer license and can take many hours. See https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/LongitudinalTutorial

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.602](https://doi.org/10.25663/brainlife.app.602)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `freesurfer` | `neuro/freesurfer` | yes | Cross-sectional FreeSurfer recon-all outputs of the same subject at different timepoints. At least two timepoints of the same subject, each with mri/norm.mgz. |

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/freesurfer/longitudinal-template` | Longitudinal template: the recon-all base subject directory (template/) plus the mri folders of each timepoint (timepoints/<id>/), as needed by Step 2/2. |

| Parameter | Type | Default | Description |
|---|---|---|---|
| `mode` | string | `base` | Fixed to base: makes main run base.sh (recon-all -base). Do not change. |

Runtime: container `brainlife/freesurfer:7.1.1`; 4 CPUs; 8 GB memory; 12 h walltime; needs `FREESURFER_LICENSE`.

<!-- brainlife-app:end -->

This App allows brainlife.io to perform freesurfer longitudinal processing

https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/LongitudinalTutorial

This App can run in 2 modes

## "base" mode

In base mode, this App will receive multiple freesurfer inputs and generate a single "base" template which can be used to run freesurfer longitudinal processing.

## "long" mode.

In long mode, this App will receive a single freesurfer input as well as the template generate from the "base" mode and output freesurfer output that contains longitudinal processing done.


