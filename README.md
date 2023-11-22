# ARES fork

This repository is a fork from the original work "Raphael J. L. Townshend et al., Geometric deep learning of RNA structure. Science373,1047-1051(2021). DOI:10.1126/science.abe5650".

The original code is from [ares_release](https://zenodo.org/records/6893040/files/ares_release.zip) and [e3nn_ares](https://zenodo.org/records/5090151/files/e3nn_ares.zip). 

This code is derived from the implementation of the docker image [adamczykb/ares_qa](https://hub.docker.com/r/adamczykb/ares_qa). 

## Installation

To install, use the Dockerfile with the following command: 
```bash
make docker_multi
```

## Usage

An example of use is the following (after running the docker container):
```bash
make predict
```