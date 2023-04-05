# Based on: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html#using-mamba-install-or-pip-install-in-a-child-docker-image
#
# Start from a rocker image
## the code below is adapted from https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/verse_4.2.2.Dockerfile

# The following line enables rocker image to run on Macbook M1/M2 chip
FROM --platform=linux/amd64 rocker/verse:4.2.2

# Customize volumes
## Volumes aren't in place yet
COPY --chown=${NB_UID}:${NB_GID} environment/ .

# Install R packages
RUN ./r-packages.R
