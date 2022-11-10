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
