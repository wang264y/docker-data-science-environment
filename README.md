# Docker for Data Science environment

This project was developed in response to [a request from the Mount Holyoke College Sociology Data Lab ](https://docs.google.com/document/d/1aEAwJX2ccDEbcrMphFKG6Z8XaFU-yQ4xG-hqFXWdCT0/edit) for assistance in creating a standardized and reproducible data science research environment. 

The template repository was developed by [Abby Drury](https://lits.mtholyoke.edu/about-lits/staff/abby-drury) in the [Academic Technologies department in LITS](https://lits.mtholyoke.edu/about-lits/departments/technology-infrastructure-systems-support/academic-technologies) in consultation with [Benjamin Gebre-Medhin](https://www.mtholyoke.edu/directory/faculty-staff/benjamin-gebre-medhin) from the Department of Sociology and Anthropology and the Data Science Committee.



## Implementation notes

This project is set up to save the environment (JupyterLab, notebooks, and R/Python packages) for the project. It is _not_ set up to keep autosave information or other [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) that are understood as incidental and unrelated to the reproducibility of the research results.

There is more detail on the Docker environment and for more details on prerequisites for the environment in [the environment README](environment/README.md).


### A warning on documentation stubs

The `analysis` and `data` directories also have their own READMEs. Please be sure to update them to reflect your project.


### JupyterLab

This repository provides the scaffolding for a Docker-based JupyterLab service/container based on the [`jupyter/datascience-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-datascience-notebook) image.



## Getting started

- Need to create a new project? [Set up a brand new environment and repository from this template for your project / team](SETTING-UP-YOUR-PROJECT.md).

- Someone already set up an environment for your project? Clone their repository, then [build and bring up JupyterLab](SETTING-UP-YOUR-PROJECT.md#3-build-and-bring-up-jupyterlab).

- Previously cloned the repository for your project and just need a refresher? Check out the [quickstart guide](QUICKSTART.md).

- Already have a cloned project and want to pull in more recent changes from the template repository? Take a look at [the instructions for working with the template repository](ADVANCED-WORK-WITH-PARENT-TEMPLATE.md)



## Working with this documentation

Ideally, references to `SERVICE_NAME`, `CONTAINER_NAME`, and `PORT_NUMBER` will be updated when [each project is set up](SETTING-UP-YOUR-PROJECT.md#4-update-references-in-the-documentation).


### Getting your service name, container name, and port

Throughout the [QUICKSTART document](QUICKSTART.md), you wil see references to `SERVICE_NAME`, `CONTAINER_NAME`, and `PORT_NUMBER`. In your project repository, you may wish to find and replace these references with the relevant values for readability.

#### Finding the SERVICE_NAME

This is in `environment/compose.yml` file, right under the `services:` key. 

In the template repository, `SERVICE_NAME` is `datascience-notebook` and is found on line 3 of the file.

#### Finding the CONTAINER_NAME

Find your container's name using `docker container ls`. The container name will be in the last column and should contain `SERVICE_NAME`. 

Note that, depending on your computer, Docker may use hyphens (`-`) or underscores (`_`) in container names. This means that the container name could be slightly different amongst your team.

In the template repository, `CONTAINER_NAME` is something like `environment_datascience-notebook_1` or `environment-datascience-notebook-1`.

#### Finding the PORT_NUMBER

This is in `environment/compose.yml` file under the `ports:` key, and is the first value in the colon (`:`) separated port numbers.

In the template repository, `PORT_NUMBER` is `10000` and is found on line 9 of the file.




## Project structure


### `analysis/`

This is where your analysis should go. These files are shared between the Docker container and your computer/the host machine, and are visible in JupyterLab. Any data that should _not_ be committed to the repository should be ignored using `data/.gitignore`.


### `data/`

This is where your data should go. These files are shared between the Docker container and your computer/the host machine, and are visible in JupyterLab. Any data that should _not_ be committed to the repository should be ignored using `data/.gitignore`.


### `environment/`

This is where the Docker, Python package, and Jupyter server configuration live. You can generally ignore most of it, but there are 4 files to be aware of.

- Python packages are specified in `environment/package-install/config/requirements.txt`. See [Python package requirements](QUICKSTART.md#python-package-requirements) for more details.
- R packages are specified in `package-install/config/r-packages.R`. See [R package requirements](QUICKSTART.md#r-package-requirements) for more details.
- JupyterLab extensions are specified in `package-install/config/jupyter-extensions.csv`. See [JupyterLab extension requirements](QUICKSTART.md#jupyterlab-extensions) for more details.
- Jupyter server configuration can be managed in `environment/jupyter_server_config.py`. You probably won't need to modify this, but it's good to know about.


### `README.md`

You're looking at it right now. :)


### `ADVANCED-WORK-WITH-PARENT-TEMPLATE.md`

This contains instructions on interacting with the parent template from an existing child project.


### `QUICKSTART.md`

This contains reminders of how to interact with your environment.


### `SETTING-UP-YOUR-PROJECT.md`

This contains instructions on how to clone the template repository, create and connect your own GitHub repository to your project, customize your environment, and build / bring up JupyterLab for the first time.
