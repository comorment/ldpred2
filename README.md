# ldpred2 project

Singularity container (via Docker image) build scripts for running statistical analysis using R and LDpred2.  

## Set up Git LFS

Container files may get large and one should never add large binary files (.sif, .zip, .tar.gz, .mat, .dat, etc.) in [git](https://git-scm.com) repositories directly, mainly files that can be parsed as raw text files (code files, etc.).
[**Git Large File Storage** (LFS)](https://git-lfs.github.com) should be used instead.
Before adding new files to this project after initialization (running `python scripts/init.py`), go through step 1-3 on the Git LFS [homepage](https://git-lfs.github.com).
Revise the `<ldpred2>/.gitattributes` file as necessary. Some common file formats has been added already.

## Build status

[![License](http://img.shields.io/:license-GPLv3+-green.svg)](http://www.gnu.org/licenses/gpl-3.0.html)
[![Documentation Status](https://readthedocs.org/projects/container-template/badge/?version=latest)](https://container-template.readthedocs.io/en/latest/?badge=latest)
[![Flake8 lint](https://github.com/espenhgn/ldpred2/actions/workflows/python.yml/badge.svg)](https://github.com/espenhgn/ldpred2/actions/workflows/python.yml)
[![Dockerfile lint](https://github.com/espenhgn/ldpred2/actions/workflows/docker.yml/badge.svg)](https://github.com/espenhgn/ldpred2/actions/workflows/docker.yml)

## Description of available containers

* ``ldpred2`` - a container setup containing R dependencies for LDpred2 plus other tools for genetic analysis

## Software versions

Below is the list of tools included in the different Dockerfile(s) and installer bash scripts for each container.
Please keep up to date (and update the main `<ldpred2>/README.md` when pushing new container builds):
  
  | container               | OS/tool             | version
  | ------------------------| ------------------- | ----------------------------------------
  | ldpred2.sif             | ubuntu              | 20.04
  | ldpred2.sif             | rocker/verse (R)    | 4.2.1
  | ldpred2.sif             | devtools (R)        | 2.4.4
  | ldpred2.sif             | bigreadr (R)        | 0.2.4
  | ldpred2.sif             | bigsnpr (R)         | 1.11.4
  | ldpred2.sif             | data.table (R)      | 1.14.2
  | ldpred2.sif             | DescTools (R)       | 0.99.46
  | ldpred2.sif             | dplyr (R)           | 1.0.10
  | ldpred2.sif             | ggplot2 (R)         | 3.3.5
  | ldpred2.sif             | fmsb (R)            | 0.7.3
  | ldpred2.sif             | magrittr (R)        | 2.0.3
  | ldpred2.sif             | reghelper (R)       | 1.1.1
  | ldpred2.sif             | tibble (R)          | 3.1.8
  | ldpred2.sif             | tidyr (R)           | 1.2.1
  | ldpred2.sif             | gctb                | 2.02
  | ldpred2.sif             | PRSice              | 2.3.5


## Examples

The directory `<ldpred2>/example` provides an example running the LDPred2 analysis. See README within.


## Building/rebuilding containers

For instructions on how to build or rebuild containers using [Docker](https://www.docker.com) and [Singularity](https://docs.sylabs.io) refer to [`<ldpred2>/src/README.md`](https://github.com/espenhgn/ldpred2/blob/main/src/README.md).

## Build the documentation

Within this repository, the html-documentation can be built from source files put here using [Sphinx](https://www.sphinx-doc.org/en/master/index.html). 
To do so, install Sphinx and some additional packages in python using [Conda](https://docs.conda.io/en/latest/) by issuing:

```
cd <ldpred2>/docs/source
conda env create -f environment.yml  # creates environment "sphinx"
conda activate sphinx  # activates environment "sphinx
make html  # builds html documentation into _build/html/ subdirectory
```

The built documentation can be viewed locally in a web browser by opening the file 
`<ldpred2>/docs/source/_build/html/index.html`

The documentation may also be hosted online on [readthedocs.org](https://readthedocs.org).

## Feedback

If you face any issues, or if you need additional software, please let us know by creating a new [issue](https://github.com/espenhgn/ldpred2/issues/new).
