# Docker-based Data Science environment

This project was developed in response to [a request from the Mount Holyoke College Sociology Data Lab to LITS](https://docs.google.com/document/d/1aEAwJX2ccDEbcrMphFKG6Z8XaFU-yQ4xG-hqFXWdCT0/edit) for assistance in creating a standardized and reproducible data science research environment.



## Prerequisites

This project requires you to install [Docker](https://www.docker.com/), and uses Docker Compose. 

Please ensure that your version of Docker includes Docker Compose version 2.0+. If you have a recentish version of Docker, you probably already do. You can check this by running `docker compose version`.


### Very basic Docker level-setting

[Docker](https://simple.wikipedia.org/wiki/Docker_(software)) is a technology that bundles a software program with all of the other software that application needs to run, such as an operating system, third-party software libraries, etc (hat tip: Simple Wikipedia).

A Docker _service_ is provided by one or more Docker _containers_ that run some application code. A Docker _container_ is created based on a Docker _image_.

#### What? 

When this document refers to the "container", it means "the instance of JupyterLab that is running in Docker on your computer/host machine". 

The concept of a Docker image is a little bit more complicated, but it's basically a blueprint that Docker uses when instantiating/creating a container. An image is typically defined in a file called `Dockerfile`. A `Dockerfile` can begin by including another image as its base that it then extends to add additional functionality (ours does this). 

The `Dockerfile` can be further configured by adding another file to enable the `docker compose` tool, which is typically named `compose.yml`. 

`docker compose` is a tool that is (now) included with a basic Docker installation that provides some additional scaffolding around the base `docker` commands to make things a little easier to deal with.

You can find out more about the specific files in the ["Project structure"](#project-structure) section of this document and in the comments within each file.

##### But you also mentioned Docker services earlier, what are those?

There is another thing called a Docker _service_. We have a pretty simple Docker use-case (in that we're probably not going to need highly scalable deployment), so we will probably run a single _service_ that runs in a single _container_ that is based on a single _image_. 

You can understand _services_ and _containers_ as basically identical for now.

###### But what _are_ they?

You could use Docker Swarm/Kubernetes/etc to run multiple Docker _containers_ that all use the same Docker _image_ -- together, those containers each provide distributed access to a Docker _service_. This means that in a Swarm/Kubernetes installation, a single service could have multiple containers handling requests in parallel. The collections of identical containers have different names in Swarm and Kubernetes ("pods", "swarms", etc). 

Kubernetes and Docker Swarm are ways to orchestrate your containers and they automagically manage request loads and spin up/cull containers and their associated resources as needed.

However, that level of complexity is likely unnecessary for this use.



## Notes on implementation

This project is set up to save the environment (JupyterLab, notebooks, and R/Python packages) for the project. It is _not_ set up to keep autosave information or other [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory) that are understood as incidental and unrelated to the reproducibility of the research results.


### JupyterLab

This repository provides the scaffolding for a Docker-based JupyterHub service/container based on the [`jupyter/datascience-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-datascience-notebook) image.


### Python package requirements

Python package requirements can be specified in `requirements.txt` and are installed using `pip`. These packages are automatically installed when the container is built. You may also [change the installed packages without rebuilding the containers](#changing-the-installed-packages).

For reproducibility, I suggest using this format to "pin" the version of the package to the exact version you are using when you add packages to the requirements file:
```python
packageName==packageVersion
```

There are references to `conda` in `Dockerfile` in addition to `pip` -- this might be a thing that we want to leverage farther/differently.


### R package requirements

__TODO__. I don't know how R manages packages.


### JupyterLab extensions

Most of these are basically just Python packages, so [add them to `requirements.txt` like any other Python package](#python-package-requirements). If the package has installation directions for `pip install`, then it can be done this way.

#### Extensions that can't be installed as Python packages

For extensions that can only be installed with `jupyter labextension install`, add the following to the end of the `Dockerfile`, then [rebuild the containers](#rebuilding-the-container):
```dockerfile
RUN jupyter labextension install <extension-name>
```

Some extensions claim to be installable via `pip`, but throw errors. You may wish to fall back to installing with `jupyter labextension install` for these as well.

For reproducibility, I suggest using this format to "pin" the version of the package to the exact version you are using when you add packages to the `Dockerfile`:
```dockerfile
RUN jupyter labextension install <extension-name>@<version>
```


### Notebooks

Notebooks that are saved in `demo-notebooks` or `work` when interacting with JupyterLab in the container will be available to version control in Git. 

Autosave files found `.ipynb_checkpoints/` are not available to version control in Git. You must be sure to save your work in JupyterLab prior to adding your changes to Git.

On your host machine, you will find the `demo-notebooks` and `work` directories that hold the `.ipynb` notebook files in `jupyter-data/`.



## Interacting with JupyterLab / Docker
You'll need some special commands in order to actually use the JupyterLab in Docker.

These commands assume that you:
- Already have Docker running 
- Have `cd`ed to the directory where the `Dockerfile` and `compose.yml` reside.



### Initially starting the container

At the command line:
```bash
docker compose up -d
```

When it's done spinning up, the container will be accessible at http://localhost:10000/.


#### Container names

To interact more deeply with the JupyterLab container, you'll sometimes need to know its name. Find it by running 
```bash
docker container list --filter name="notebook"
```

The container name is the one in the right-most column. Use it in place of `containerName` in the commands in this document.


#### Getting your random authentication token for logging into the web interface

This does change every time you rebuild the container.

At the command line:
```bash
docker exec -it containerName jupyter server list
```

__TODO__ explore a different authentication method that isn't this annoying.



### Stopping the container

At the command line:
```bash
docker compose stop
```


### Starting the container again

You don't necessarily have to do `docker compose up -d` again. Instead you can just do:
``` bash
docker compose start
```


### Rebuilding the container 

At the command line:
```bash
docker compose build
docker compose up -d
```


### Changing the installed packages

Edit `requirements.txt` to add your Python packages, then at the command line:
```bash
docker exec -it containerName pip install --no-cache-dir --quiet --requirement ./requirements.txt
```



## Project structure


### `jupyter-data/`

This is the stuff that is shared between the Docker container and your computer/the host machine.

#### `requirements.txt`

A classic [`requirements.txt`](https://pip.pypa.io/en/stable/reference/requirements-file-format/) file that defines what Python packages should be installed. It also can (and should) define what version of each package should be used.

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


### `README.md`

You're looking at it right now. :)



## Publishing thoughts

1. We may want some way to export/publish `.ipynb` files to pure Python/R/whatever so that the ability to run the code isn't dependent on having JuptyerLab in the future. Probably publishing would be a manual step that you have to consciously do, rather than something automatic.
    1. Versioning Python/R itself....not sure how to do that  since it's coming from JupyterLab. Looking at the `.ipynb` file, I do actually see the Python version information in there. That's great if the code is running in a relevant version of JupyterLab, but doesn't help if the code is published in pure Python.
    1. It's kind of unclear whether the version of JupyterLab is pinned in the Docker image?
1. We should bring Sarah O. in again. They will hopefully be able to advise around the best practices for what a published dataset/notebook/etc should look like, and I can help with the technical side of accomplishing that.
