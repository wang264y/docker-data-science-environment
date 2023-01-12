# Structure

## Docker elements

### `compose.yml` and `Dockerfile`

These files define the configuration for the Docker part of the environment. The container is based on the [`jupyter/datascience-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-datascience-notebook) image, maps the project directories on your host machine to `/home/jovyan` in the container, and installs the configured packages.

## DS Environment files


### [`requirements.txt`](requirements.txt)

Additional Python packages.


### [`r-packages.R`](r-packages.R)

Additional R packages.


### [`jupyter-extensions.csv`](jupyter-extensions.csv)

Additional JupyterLab extensions. 


## Supporting files

### [`install-jupyter-extensions.sh`](install-jupyter-extensions.sh)

This script installs the JupyterLab extensions, and is run by the `Dockerfile`.


### [`jupyter_server_config.py`](jupyter_server_config.py)

This is where you can make changes to the Jupyter server configuration. By default, it sets the JupyterLab UI to launch in the `analysis` folder of the main project and removes server authentication since this project is only meant to be run on a researcher's computer and not in a shared or production environment.


# Building, starting, and stopping a container


## Assumptions

- Docker is running
- You have a terminal session and your current working directory is the main project directory. 


## Building a container


## Starting a container


## Stopping a container
