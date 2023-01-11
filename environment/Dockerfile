# Based on: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html#using-mamba-install-or-pip-install-in-a-child-docker-image
#
# Start from a core stack version
FROM jupyter/datascience-notebook:9e63909e0317

# Volumes aren't in place yet 
COPY --chown=${NB_UID}:${NB_GID} environment/ .

# Install Python packages from requirements.txt file
RUN pip install --quiet --no-cache-dir --requirement ./requirements.txt && \
  fix-permissions "${CONDA_DIR}" && \
  fix-permissions "/home/${NB_USER}"

# Install R packages
RUN ./r-packages.R

# Install JupyterLab extensions 
RUN ./install-jupyter-extensions.sh
