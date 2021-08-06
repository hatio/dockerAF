
# Bioinformatics Analysis Containers

This repository stores the instructions (including scripts) to build, install, and use
bioinformatics analysis pipelines of Virology, AFRIMS to
assure their reproducibility and portability.

The recommended way to stay up-to-date with this repository is through cloning this repo using the following code (assumes that you have [git](https://git-scm.com/downloads) installed):

    git clone https://github.com/hatio/dockerAF.git
    cd dockerAF

You are now at the *root directory* of the repository.


## Directory dictionaries

- `01-buildContainer`: scripts to build the containers
- `02-setupPipeline`: scripts to setup the containers on a machine
- `03-runPipeline`: scripts to run the pipelines (may involve one or more containers)

`00-providedFiles` stores pipelines/scripts prior migrating to the container solutions.
These are meant for communications between pipeline developers.
Users of the pipelines should ignore these.
