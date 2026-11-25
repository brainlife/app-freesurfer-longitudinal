<h1 align="center">FreeSurfer longitudinal processing</h1>

<p align="center">
  A within-subject template and longitudinally processed FreeSurfer outputs from cross-sectional FreeSurfer runs of the same subject at several timepoints.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.602"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.602-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Builds a FreeSurfer 7.1.1 longitudinal base (within-subject template) from several cross-sectional FreeSurfer outputs of the same subject with recon-all -base; step 1 of 2 of longitudinal processing.**

Runs recon-all -base -all over all input FreeSurfer outputs (timepoints named by the md5 of their norm.mgz) to create an unbiased within-subject template. Use it before Step 2/2, which runs recon-all -long for each timepoint against this template. All inputs must be cross-sectional FreeSurfer runs of the same subject; requires a FreeSurfer license and can take many hours. See https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/LongitudinalTutorial

| | |
|---|---|
| 📥 **Inputs** | `neuro/freesurfer` |
| 📤 **Outputs** | `neuro/freesurfer/longitudinal-template` |
| 🐳 **Container** | `brainlife/freesurfer:7.1.1` |
| ⚙️ **Resources** | 4 CPUs · 8 GB memory · 12 h walltime |
| 🔑 **Requires** | `FREESURFER_LICENSE` |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.602](https://doi.org/10.25663/brainlife.app.602) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `freesurfer` | `neuro/freesurfer` | yes | Cross-sectional FreeSurfer recon-all outputs of the same subject at different timepoints. At least two timepoints of the same subject, each with mri/norm.mgz. |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `output` | `neuro/freesurfer/longitudinal-template` | Longitudinal template: the recon-all base subject directory (template/) plus the mri folders of each timepoint (timepoints/<id>/), as needed by Step 2/2. |

<details>
<summary><b>⚙️ Parameters</b> (1)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `mode` | string | `base` | Fixed to base: makes main run base.sh (recon-all -base). Do not change. |

</details>

<!-- brainlife-app:end -->

## 🏷️ Versions on brainlife.io

This repository implements the two steps of the [FreeSurfer longitudinal stream](https://surfer.nmr.mgh.harvard.edu/fswiki/FsTutorial/LongitudinalTutorial). Each step is a separate App on brainlife.io, built from the same branch; the `mode` option selects the step.

| App | FreeSurfer | Branch | Run it | Status |
|---|---|---|---|---|
| Freesurfer 7.1.1 Longitudinal (Step1/2): base template (`mode: base`) | 7.1.1 | [`main`](https://github.com/brainlife/app-freesurfer-longitudinal/tree/main) | [doi:10.25663/brainlife.app.602](https://doi.org/10.25663/brainlife.app.602) | current |
| Freesurfer 7.1.1 Longitudinal (Step 2/2): longitudinal run (`mode: long`) | 7.1.1 | [`main`](https://github.com/brainlife/app-freesurfer-longitudinal/tree/main) | [doi:10.25663/brainlife.app.603](https://doi.org/10.25663/brainlife.app.603) | current |

## 🚀 Running the App

### ☁️ On brainlife.io

1. **Step 1/2 (base).** Open [doi.org/10.25663/brainlife.app.602](https://doi.org/10.25663/brainlife.app.602) and choose the cross-sectional FreeSurfer outputs (`neuro/freesurfer`) of one subject at two or more timepoints. The App runs `recon-all -base` and archives a `neuro/freesurfer/longitudinal-template` dataset to your project.
2. **Step 2/2 (long).** Open [doi.org/10.25663/brainlife.app.603](https://doi.org/10.25663/brainlife.app.603) once per timepoint, choose that timepoint's FreeSurfer output and the template from Step 1, and press **Execute**. The App runs `recon-all -long` and archives a FreeSurfer output tagged `longitudinal`.

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/) and a [FreeSurfer license](https://surfer.nmr.mgh.harvard.edu/registration.html). The `brainlife/freesurfer:7.1.1` container is pulled from Docker Hub on first use.

1. Clone this repository.
2. For Step 1, create `config.json` from `config.json.base-template`, listing the FreeSurfer output directories of every timepoint:

   ```json
   {
       "mode": "base",
       "freesurfers": [
           "/input/tp1/output",
           "/input/tp2/output",
           "/input/tp3/output"
       ]
   }
   ```

   For Step 2, create `config.json` from `config.json.long-template`, pointing to one timepoint and to the `template` and `timepoints` directories written by Step 1:

   ```json
   {
       "mode": "long",
       "freesurfer": "/input/tp1/output",
       "template": "/input/base/template",
       "timepoints": "/input/base/timepoints"
   }
   ```

3. Export your license and run the App:

   ```bash
   export FREESURFER_LICENSE="$(cat ~/freesurfer/license.txt)"
   ./main
   ```

## 📦 Outputs

Step 1 (base):

```text
output/
├── template/           recon-all base subject directory (the within-subject template)
└── timepoints/<id>/mri the mri folder of each timepoint, needed by Step 2
```

Step 2 (long): `output/output` is the FreeSurfer subject directory of the longitudinally processed timepoint (`<id>.long.template`), with the usual `label/`, `mri/`, `scripts/`, `stats/` and `surf/` folders.

Timepoints are identified by the MD5 checksum of their `mri/norm.mgz`, which is used as `<id>`.

## 🩺 Troubleshooting

- **`Please set FREESURFER_LICENSE in .bashrc`**: export the contents of your FreeSurfer `license.txt` in `FREESURFER_LICENSE` before running `./main`.
- **Step 2 cannot find the timepoint in the template**: the FreeSurfer output given to Step 2 must be one of the timepoints used to build the template; it is matched by the MD5 of its `mri/norm.mgz`, so a re-run or modified FreeSurfer output will not match.
- **All inputs to Step 1 must be cross-sectional FreeSurfer runs of the same subject.** Each step can take many hours.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Freesurfer 7.1.1 Longitudinal (Step1/2). brainlife.io App. [doi:10.25663/brainlife.app.602](https://doi.org/10.25663/brainlife.app.602)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Soichi Hayashi

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

[MIT](LICENSE). FreeSurfer itself is distributed under its own [license](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense).
