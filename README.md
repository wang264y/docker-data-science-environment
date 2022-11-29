# Quickstart guide

This project was developed in response to [a request from the Mount Holyoke College Sociology Data Lab to LITS](https://docs.google.com/document/d/1aEAwJX2ccDEbcrMphFKG6Z8XaFU-yQ4xG-hqFXWdCT0/edit) for assistance in creating a standardized and reproducible data science research environment.

There is more detail on the Docker environment and for more details on prerequisites for the environment in [the environment README](environment/README.md).

**TODO** `analysis` and `data` also have their own READMEs. Please be sure to update them to reflect your project.



## Notes on implementation

This project is set up to save the environment (JupyterLab, notebooks, and R/Python packages) for the project. It is _not_ set up to keep autosave information or other [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) that are understood as incidental and unrelated to the reproducibility of the research results.


### JupyterLab

This repository provides the scaffolding for a Docker-based JupyterLab service/container based on the [`jupyter/datascience-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-datascience-notebook) image.



## Interacting with JupyterLab / Docker

You'll need some special commands in order to actually use the JupyterLab in Docker.

These commands assume that you:
- Already have Docker running.
- Have opened a shell and `cd`ed to the root directory for this project, which is the directory in which this file resides.


### Build and bring up JupyterLab 

At the command line:
```bash
docker compose -f environment/compose.yml build
docker compose -f environment/compose.yml up -d
```

It takes a while after the second command returns for the container to become available, as it builds and installs all of the extensions and packages for JupyterLab. You can either wait a while, or monitor the startup progress by [viewing the Docker logs](#view-the-docker-container-logs).

If you are monitoring the logs, the container is ready when this message appears:

 ```bash
 [I yyyy-MM-dd HH:mm:ss.SSS ServerApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
 ```

When it's done spinning up, the container will be accessible at http://localhost:10000/


### Stop JupyterLab

At the command line:
```bash
docker compose -f environment/compose.yml stop
```


### Start JupyterLab after stopping it

At the command line:
```bash
docker compose -f environment/compose.yml start
```


### View the Docker container logs

At the command line:
```bash
docker logs -f environment_datascience-notebook_1
```

**NOTE** if this command doesn't work, find your container's name using `docker container ls`. The container name will be in the last column and should contain `datascience-notebook`. Replace `environment_datascience-notebook_1` in the log command above with your container's name.

You can exit the logs using the key command `control+c` (also sometimes written as `^C`).



## Add packages and extensions

### Python package requirements

Python package requirements can be specified in `environment/package-install/config/requirements.txt`. This is a classic [`requirements.txt`](https://pip.pypa.io/en/stable/reference/requirements-file-format/).

For reproducibility, you should specify the version of the package to the exact version you are using when you add packages to the requirements file:
```python
packageName==packageVersion
```

If you change the requirements, you will need to [install packages and extensions](#install-packages-and-extensions) in order for those changes to take effect.


### R package requirements

1. Find the package on cran.r-project.org (eg: https://cran.r-project.org/package=XML)
1. Find the appropriate version of the package, either in the "Package source" link or on the "Old sources" archive page.
1. In `environments/package-install/config/r-packages.R` add the package name and version on a new line:
    ```R
    if (! require("XML") || packageVersion("XML") != "3.99.0.3") { install_version("XML", version="3.99.0.3") }
    ```
    This checks whether the package is already installed and at the proper version, and installs it if it is missing or at the wrong version.
1. [Install packages and extensions](#install-packages-and-extensions).

Hints:
1. If the most recent version of the package won't install, you can figure out the most recent compatible version by running `packages.install("package-name")` in an R notebook in JupyterLab, then running `packageVersion("package-name")`. Then, be sure to find that version on cran.r-project.org and add that version of the package to `environments/package-install/config/r-packages.R`.


### JupyterLab extensions

1. Find the extension and version that you want.
1. Add the extension name and version to `environment/package-install/config/jupyter-extensions.txt` as a new line.
    1. If the extension can be installed successfully via `pip`, use the following syntax:
        ```csv
        ipympl,0.9.2
        ```
    1. If the extension cannot be installed using `pip` or otherwise must be installed using `jupyter labextension install`, use the following syntax:
        ```csv
        jupyterlab-spreadsheet,0.4.1,manual
        ```
1. [Install packages and extensions](#install-packages-and-extensions).


### Install packages and extensions

You can install the currently specified packages and extensions into a running container with:
```bash
docker compose -f environment/compose.yml exec datascience-notebook ./environment/package-install/install-packages-and-extensions.sh 
```

You can also install packages and extensions by [rebuilding the container](#rebuilding-the-container).

#### The lockfiles

The project does use lockfiles to prevent repeated attempts to install packages if the configuration file hasn't changed. You can detect this in the [container logs](#view-the-docker-container-logs), after running `install-packages-and-extensions.sh`. 

You can force an install attempt for all packages and extensions by adding the `--force` flag:
```bash
docker compose -f environment/compose.yml exec datascience-notebook ./environment/package-install/install-packages-and-extensions.sh --force
```



## Project structure


### `analysis/`

This is where your analysis should go. These files are shared between the Docker container and your computer/the host machine, and are visible in JupyterLab. Any data that should _not_ be committed to the repository should be ignored using `data/.gitignore`.


### `data/`

This is where your data should go. These files are shared between the Docker container and your computer/the host machine, and are visible in JupyterLab. Any data that should _not_ be committed to the repository should be ignored using `data/.gitignore`.


### `environment/`

This is where the Docker, Python package, and Jupyter server configuration live. You can generally ignore most of it, but there are 4 files to be aware of.

- Python packages are specified in `environment/package-install/config/requirements.txt`. See [Python package requirements](#python-package-requirements) for more details.
- R packages are specified in `package-install/config/r-packages.R`. See [R package requirements](#r-package-requirements) for more details.
- JupyterLab extensions are specified in `package-install/config/jupyter-extensions.csv`. See [JupyterLab extension requirements](#jupyterlab-extensions) for more details.
- Jupyter server configuration can be managed in `environment/jupyter_server_config.py`. You probably won't need to modify this, but it's good to know about.



### `README.md`

You're looking at it right now. :)

