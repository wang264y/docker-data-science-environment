# Docker-based Data Science environment

This project was developed in response to [a request from the Mount Holyoke College Sociology Data Lab to LITS](https://docs.google.com/document/d/1aEAwJX2ccDEbcrMphFKG6Z8XaFU-yQ4xG-hqFXWdCT0/edit) for assistance in creating a standardized and reproducible data science research environment.



## Prerequisites

This project requires you to install [Docker](https://www.docker.com/), and uses Docker Compose. 

Please ensure that your version of Docker includes Docker Compose version 2.0+. You can check this by running `docker compose version`.


### Very basic Docker level-setting

A Docker _container_ is created based on a Docker _image_. The Docker image is a blueprint that Docker uses when instantiating a container. When this document refers to the "container", it means "the instance of JupyterLab that is running in Docker on your computer/host machine". 

You may see _container_ and _service_ used seemingly interchangeably in your adventures across the internet. If this were running in a highly scalable environment (Docker Swarm, Kubernetes, whatever), a single service could have multiple containers handling requests in parallel. For this project, we're unlikely to require that kind of complexity, so you can understand them as basically identical for now -- each service will run in exactly one container.

__TL;DR:__ You could run multiple Docker _containers_ that all use the same Docker _image_ -- together, those containers would be called a Docker _service_. You probably won't for this project, but you could. In our case, you will probably run a single _service_ that runs in a single _container_ that is based on a single _image_.



## Notes on implementation

This project is set up to save the environment (JupyterLab, notebooks, and R/Python packages) for the project. It is _not_ set up to keep autosave information or other [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) that are understood as incidental and unrelated to the reproducibility of the results.


### JupyterLab

This repository provides the scaffolding for a Docker-based JupyterHub service/container based on the [`jupyter/datascience-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-datascience-notebook) image.


### Python package requirements

Python package requirements can be specified in `requirements.txt`. These packages are automatically installed when the container is built. You may also [change the installed packages without rebuilding the containers](#changing-the-installed-packages).

For reproducibility, I suggest using this format to "pin" the version of the package to the exact version you are using when you add packages to the requirements file:
```python
packageName==packageVersion
```


### R package requirements

__TODO__.


### Notebooks

Notebooks that are saved in `demo-notebooks` or `work` when interacting with JupyterLab in the container will be available to version control in Git. 

Autosave files found `.ipynb_checkpoints/` are not available to version control in Git. You must be sure to save your work in JupyterLab prior to adding your changes to Git.

On your host machine, you will find the `demo-notebooks` and `work` directories that hold the `.ipynb` notebook files in `jupyter-data/`.



## Interacting with JupyterLab / Docker
You'll need some special commands in order to actually use the JupyterLab in Docker.



### Initially starting the container

At the command line:
```bash
$ docker compose up -d
```

When it's done spinning up, the container will be accessible at http://localhost:10000/.


#### Container names

To interact more deeply with the JupyterLab container, you'll sometimes need to know its name. Find it by running 
```bash
$ docker container list --filter name="notebook"
```

The container name is the one in the right-most column. Use it in place of `containerName` in the commands in this document.


#### Getting your random authentication token for logging into the web interface

This does change every time you rebuild the container.

At the command line:
```bash
$ docker exec -it containerName jupyter server list
```

**TODO** explore a different authentication method that isn't this annoying.



### Stopping the container

At the command line:
```bash
$ docker compose stop
```


### Starting the container again

You don't necessarily have to do `docker compose up -d` again. Instead you can just do:
``` bash
$ docker compose start
```


### Rebuilding the container 

At the command line:
```bash
$ docker compose build
$ docker compose up -d
```


### Changing the installed packages

Edit `requirements.txt` to add your Python packages, then at the command line:
```bash
$ docker exec -it containerName pip install --no-cache-dir --requirement /tmp/requirements.txt
```



## Project structure


### `jupyter-data/`

This is the stuff that is shared between the Docker container and your computer/the host machine.

#### `jupyter-data/demo-notebooks/get-url-in-python.ipynb`

This notebook uses Python to retrieve a given URL (google.com), print the HTML response code, and then print the HTML contents of that URL.

#### `jupyter-data/demo-notebooks/hello-world-in-r.ipynb`

This notebook uses R to execute a classic "hello world" program.


#### `work`

This could also hold notebooks, and was generated (I think) automatically by JupyterLab.


### `.gitignore`

A classic [`.gitignore`](https://git-scm.com/docs/gitignore) file for specifying what files Git should consider as not eligible for version control. This is how we exclude autosave information from our repository.


### `Dockerfile` and `compose.yml`

These two files work together to create the Docker environment.

`Dockerfile` defines the Docker image for the container, and `compose.yml` defines the Docker service that uses that image. 

The connections between the filesystem inside the Docker container and the host machine, the configuration to make JupyterHub available at `localhost:1000`, and the automatic installation of the packages in `requirements.txt` are defined in these files.


### `requirements.txt`
A classic [`requirements.txt`](https://pip.pypa.io/en/stable/reference/requirements-file-format/) file that defines what Python packages should be installed. It also can (and should) define what version of each package should be used.


### 'README.md`

You're looking at it right now. :)



## Publishing thoughts

1. We may want some way to export/publish `.ipynb` files to pure Python/R/whatever so that the ability to run the code isn't dependent on having JuptyerLab in the future. Probably publishing would be a manual step that you have to consciously do, rather than something automatic.
    1. Versioning Python/R itself....not sure how to do that  since it's coming from JupyterLab. Looking at the `.ipynb` file, I do actually see the Python version information in there. That's great if the code is running in a relevant version of JupyterLab, but doesn't help if the code is published in pure Python.
    1. It's kind of unclear whether the version of JupyterLab is pinned in the Docker image?
1. We should bring Sarah O. in again. They will hopefully be able to advise around the best practices for what a published dataset/notebook/etc should look like, and I can help with the technical side of accomplishing that.
