# Based on: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html#using-mamba-install-or-pip-install-in-a-child-docker-image
#
# Start from a core stack version
FROM jupyter/datascience-notebook:9e63909e0317

# Install from requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} ./jupyter-data/requirements.txt .
RUN pip install --quiet --no-cache-dir --requirement ./requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install extensions that aren't installable using pip
# The install syntax is weird here, in order to pin a specific version:
#   jupyter labextension install <extension-name>@<version>
RUN jupyter labextension install jupyterlab-spreadsheet@0.4.1

