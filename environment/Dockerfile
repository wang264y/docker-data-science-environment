# Based on: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html#using-mamba-install-or-pip-install-in-a-child-docker-image
#
# Start from a rocker image
## the code below is adapted from https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/verse_4.2.2.Dockerfile

FROM rocker/tidyverse:4.2.2

LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
      org.opencontainers.image.source="https://github.com/rocker-org/rocker-versioned2" \
      org.opencontainers.image.vendor="Rocker Project" \
      org.opencontainers.image.authors="Carl Boettiger <cboettig@ropensci.org>"

ENV CTAN_REPO=https://www.texlive.info/tlnet-archive/2023/03/14/tlnet
ENV PATH=$PATH:/usr/local/texlive/bin/linux

RUN /install_verse.sh

# Customize volumes
## Volumes aren't in place yet
COPY --chown=${NB_UID}:${NB_GID} environment/ .

# Install R packages
RUN ./r-packages.R
