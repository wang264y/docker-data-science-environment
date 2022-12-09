# Quickstart 



## Need more help?

While we endeavor to make this documentation as helpful as possible, sometimes documentation is not enough.

- For assistance with a specific environment that uses this template repository, contact [your project sponsor](#contact-info-here).

- For assistance with the template repository, contact the [Academic Technologies department in LITS](https://lits.mtholyoke.edu/about-lits/departments/technology-infrastructure-systems-support/academic-technologies).



## Interacting with JupyterLab / Docker every day

You'll need some special commands in order to actually use the JupyterLab in Docker.

These commands assume that you:
- Already have Docker running.
- Have at some point previously [build and brought up JupyterLab](SETTING-UP-YOUR-PROJECT.md#3-build-and-bring-up-jupyterlab) for your environment.
- Know the `SERVICE_NAME`, `CONTAINER_NAME`, and `PORT_NUMBER` for your project OR someone has already updated these directions to fill in these references.
- Have opened a shell and `cd`ed to the root directory for this project, which is the directory in which this file resides.


### Access JupyterLab in your browser

It takes a while after the `up -d` command returns for the container to become available, as it builds and installs all of the extensions and packages for JupyterLab. You can either wait a while, or monitor the startup progress by [viewing the Docker logs](#view-the-docker-container-logs).

When it's done spinning up, the container will be accessible at `http://localhost:PORT_NUMBER/` (eg. http://localhost:10000).


### Stop JupyterLab

1. **IMPORTANT:** Before you stop JupyterLab, make sure that you've [added any new packages or extensions to the configuration](#add-packages-and-extensions). If you've made changes to packages or extensions directly in JupyterLab without migrating those changes to the configuration, you will not be able to share those changes and may lose those changes yourself.

1. To stop the JupyterLab Docker container, at the command line:
    ```bash
    docker compose -f environment/compose.yml stop
    ```


### Start JupyterLab after stopping it

1. To start the JupyterLab Docker container, at the command line:
    ```bash
    docker compose -f environment/compose.yml start
    ```


### View the Docker container logs

1. To view the Docker container logs, at the command line:
    ```bash
    docker logs -f CONTAINER_NAME
    ```

    If you have trouble with this command, [double check your container name](README.md#finding-the-container_name).



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

**HINT:** If the most recent version of the package won't install, you can figure out the most recent compatible version by running `packages.install("package-name")` in an R notebook in JupyterLab, then running `packageVersion("package-name")`. Then, be sure to find that version on cran.r-project.org and add that version of the package to `environments/package-install/config/r-packages.R`.


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
docker compose -f environment/compose.yml exec SERVICE_NAME ./environment/package-install/install-packages-and-extensions.sh 
```

You can also install packages and extensions by [rebuilding the container](SETTING-UP-YOUR-PROJECT.md#3-build-and-bring-up-jupyterlab).

#### The lockfiles

The project does use lockfiles to prevent repeated attempts to install packages if the configuration file hasn't changed. You can detect this in the [container logs](#view-the-docker-container-logs), after running `install-packages-and-extensions.sh`. 

You can force an install attempt for all packages and extensions by adding the `--force` flag:
```bash
docker compose -f environment/compose.yml exec SERVICE_NAME ./environment/package-install/install-packages-and-extensions.sh --force
```
