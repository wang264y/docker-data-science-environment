# Quickstart guide

This project was developed in response to [a request from the Mount Holyoke College Sociology Data Lab to LITS](https://docs.google.com/document/d/1aEAwJX2ccDEbcrMphFKG6Z8XaFU-yQ4xG-hqFXWdCT0/edit) for assistance in creating a standardized and reproducible data science research environment.

There is more detail on the Docker environment and for more details on prerequisites for the environment in [the environment README](environment/README.md).

**TODO** `analysis` and `data` also have their own READMEs. Please be sure to update them to reflect your project.



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

When it's done spinning up, the container will be accessible at http://localhost:10000/

#### Getting your random authentication token for logging into the web interface

This does change every time you rebuild the container / randomly.

At the command line:
```bash
docker compose -f environment/compose.yml exec datascience-notebook jupyter server list
```

__TODO__ explore a different authentication method that isn't this annoying.


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



## Add packages and extensions


### Python package requirements

Python package requirements can be specified in `analysis/requirements.txt` and are installed using `pip`. These packages are automatically installed when the container is built. You may also [change the installed packages without rebuilding the containers](#changing-the-installed-packages).

For reproducibility, I suggest using this format to "pin" the version of the package to the exact version you are using when you add packages to the requirements file:
```python
packageName==packageVersion
```


### R package requirements

1. Find the package on cran.r-project.org (eg: https://cran.r-project.org/package=XML)
1. Find the appropriate version of the package, either in the "Package source" link or on the "Old sources" archive page.
1. In `environments/Dockerfile` add a line like this, and modify it to use the URL from the previous step for the first parameter:
    ```dockerfile
    RUN R -e "install.packages('https://cran.r-project.org/src/contrib/Archive/XML/XML_3.99-0.3.tar.gz', repos=NULL, type='source')"
    ```

Hints:
1. You can also sometimes find `tar.gz` files for R packages on GitHub.
1. If the most recent version of the package won't install, you can figure out the most recent compatible version by running `packages.install("package-name")` in an R notebook in JupyterLab, then running `packageVersion("package-name")`. Then, be sure to find that version on GitHub or on cran.r-project.org and add that version of the package to `environments/Dockerfile`.

### JupyterLab extensions

Most of these are basically just Python packages, so [add them to `analysis/requirements.txt` like any other Python package](#python-package-requirements). If the package has installation directions for `pip install`, then it can be done this way.

#### Extensions that can't be installed as Python packages

For extensions that can only be installed with `jupyter labextension install`, add the following to the end of `environments/Dockerfile`, then [rebuild the containers](#rebuilding-the-container). For reproducibility, I suggest using this format to "pin" the version of the package to the exact version you are using when you add packages to `environments/Dockerfile`:
```dockerfile
RUN jupyter labextension install <extension-name>@<version>
```

Some extensions claim to be installable via `pip`, but throw errors. You may wish to fall back to installing with `jupyter labextension install` for these as well.



## Install new package or extension requirements

You can apply changes in `analysis/requirements.txt` by running: 
```bash
docker compose -f environment/compose.yml exec datascience-notebook pip install --no-cache-dir --quiet --requirement ./requirements.txt
```

For all other changes, [build and start JupyterLab](#build-and-start-jupyterlab) again.



## Project structure


### `analysis/`

This is where your analysis should go. These files are shared between the Docker container and your computer/the host machine, and are visible in JupyterLab. Any data that should _not_ be committed to the repository should be ignored using `data/.gitignore`.

### `data/`

This is where your data should go. These files are shared between the Docker container and your computer/the host machine, and are visible in JupyterLab. Any data that should _not_ be committed to the repository should be ignored using `data/.gitignore`.


### `environment/`

This is where the Docker configuration lives. You may need to modify `environment/Dockerfile` to add R packages or some JupyterLab extensions, but otherwise you can kind of ignore these files.


### `README.md`

You're looking at it right now. :)

