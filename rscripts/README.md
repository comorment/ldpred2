# rscripts

## LDpred2.R script

We here provide an R script (`LDpred2.R`) which can be executed using built containers either in Docker (locally) or Singularity (HPC) formats.
The R script is based on an example/tutorial from the [`bigsnpr` GitHub repository](https://github.com/privefl/bigsnpr), 
specifically [R markdown file](https://github.com/privefl/bigsnpr/blob/master/vignettes/LDpred2.Rmd).

Please confer this [tutorial](https://privefl.github.io/bigsnpr/articles/LDpred2.html) for some more detailed explainations of the actual codes.

## LDpred2.Rmd

```
Rscript -e "rmarkdown::render('LDpred2.Rmd',params=list(args = myarg))"
```

## tutorial_data directory

This directory includes some files used by the [tutorial](https://privefl.github.io/bigsnpr/articles/LDpred2.html) here included in the directory from
[https://figshare.com/ndownloader/files/37802721](https://figshare.com/ndownloader/files/37802721) and 

### Docker

Run using Docker container, e.g., for local testing/development without singularity

In case you wish to build the image, clone the entire repository, change directory to this one and issue
```
docker build -t ldpred2 -f ../src/dockerfiles/ldpred2/Dockerfile .
```
The build may take some time, and is assigned the ID `ldpred2`.

Then, one may mount the working directory to `/tools/` and run the example using `Rscript` as:
```
docker run -p 49634:49634 --mount type=bind,source=$(pwd),target=/tools/ ldpred2 Rscript /tools/LDpred2.R
```

### Singularity




### Singularity + Slurm

