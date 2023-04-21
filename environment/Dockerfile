# Based on: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html#using-mamba-install-or-pip-install-in-a-child-docker-image
#
# Start from a core stack version
FROM jupyter/r-notebook:2023-04-10

# Volumes aren't in place yet
COPY --chown=${NB_UID}:${NB_GID} environment/ .


# Install R packages
RUN ./r-packages.R

# Install JupyterLab extensions
RUN ./install-jupyter-extensions.sh
