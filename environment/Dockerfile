# Based on: https://jupyter-docker-stacks.readthedocs.io/en/latest/using/recipes.html#using-mamba-install-or-pip-install-in-a-child-docker-image
#
# Start from a core stack version
FROM jupyter/datascience-notebook:9e63909e0317

# Install Python packages from requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} ./analysis/requirements.txt .
RUN pip install --quiet --no-cache-dir --requirement ./requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Install R packages from sources (CRAN, GitHub, etc - anywhere with .tar.gz install files)
RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/XML/XML_3.99-0.3.tar.gz', repos=NULL, type='source')"

# Install JupyterLab extensions that aren't installable using pip
# The install syntax is weird here, in order to pin a specific version:
#   jupyter labextension install <extension-name>@<version>
RUN jupyter labextension install jupyterlab-spreadsheet@0.4.1
RUN jupyter labextension install @lckr/jupyterlab_variableinspector@3.0.7
