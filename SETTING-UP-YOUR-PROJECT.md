# Setting up a project / environment

To set up a project that you can share amongst your team using GitHub, there are a few steps that you need to take.



## Prerequisites

1. You must have a GitHub account, and your GitHub account must have access to [the template repository](https://github.com/mtholyoke/docker-data-science-environment/). 
    1. If you're reading this, you're all set.
    1. If you need access to this repository, contact the [Academic Technologies department in LITS](https://lits.mtholyoke.edu/about-lits/departments/technology-infrastructure-systems-support/academic-technologies).
1. This guide assumes that you have a command-line interface that can run `bash` commands, including `git`. 
    1. Macs ship with an application called Terminal. Terminal should come with Git already installed.
    1. Windows machines will need a Git client, we recommend [Git for Windows](https://gitforwindows.org/).
    1. Most Linux distros will ship with some kind of command-line application. They also often ship with Git installed.



## 1. Initially cloning the template to a your own project

1. On your computer, choose where you will save this project. In your command-line interface/terminal, change to the place where you will save the project (eg `~/Projects`):
    ```bash
    cd ~/Projects
    ```

1. Decide on a machine-readable project name. Do not use spaces in the name, instead use hyphens (`-`) or underscores (`_`). Choose something relevant to your project. Use this value in place of `your-project-name` going forward.

1. Clone the parent template into a directory named for your project:
    ```bash
    git clone git@github.com:mtholyoke/docker-data-science-environment.git your-project-name
    ```

    If this fails, contact the [Academic Technologies department in LITS](https://lits.mtholyoke.edu/about-lits/departments/technology-infrastructure-systems-support/academic-technologies) to troubleshoot your access to the repository.

1. Change directory into your project:
    ```bash
    cd your-project-name
    ```

1. In your project, rename the template repository's origin for clarity:
    ```bash
    git remote rename origin template
    ```

    This is the connection to the template repository on GitHub

1. Disallow pushing from your project to the template repository:
    ```bash
    git remote set-url --push template no_push
    ```

    You won't have permissions to push to the template repository anyway, but this makes it even more explicit.

1. [Create an empty repository on Github for your project](https://github.com/new). 

    Use `your-project-name` as the name of the repository, and don't add a `README` file or `.gitignore` files when doing creating the repository. 

1. Connect your local project to that new, empty repository at GitHub:
    ```bash
    git remote add origin git@github.com:you/your-project-name.git
    ```
    You can find what to use for `git@github.com:you/your-project-name.git` by visiting your new project repository on github.com and clicking on the green "<> Code" button. Your repository's information will be found in the text field on the "SSH" tab of the "Clone" pane.

1. Ensure that the default branch of your project is named `main`:
    ```bash
    git branch -M main
    ```
  
1. Push your branch to your new repository at GitHub:
    ```bash
    git push -u origin
    ```



## 2. Configure your specific environment

1. Before you [build and bring up JupyterLab](#3-build-and-bring-up-jupyterlab), edit `environment/compose.yml` and change:
    1. The service name from `datascience-notebook` to something else, possibly `your-project-name` for simplicity. This will be the base of the Docker container's name. Do not use spaces, instead use hyphens (`-`) or underscores (`_`).
    1. The first half of the port entry from `10000` to something else - I suggest incrementing by one each time (eg `10001`, `10002`, etc).

1. When you bring up JupyterLab, you may see this warning. That's okay, you can ignore it.
    ```bash
    WARN[0000] Found orphan containers ([<some_container_name>]) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up. 
    ```



## 3. Build and bring up JupyterLab 

These commands assume that you:
- Already have Docker running.
- Have opened a shell and `cd`ed to the root directory for this project, which is the directory in which this file resides.


At the command line:
```bash
docker compose -f environment/compose.yml build
docker compose -f environment/compose.yml up -d
```



## 4. Update references in the documentation

1. In the [QUICKSTART file](QUICKSTART.md), find and replace `SERVICE_NAME`, `CONTAINER_NAME`, and `PORT_NUMBER` with the appropriate values. Guidance on how to find those values is located in that file.

1. In the ["Need more help?" section of the QUICKSTART file](QUICKSTART.md#need-more-help), update the project sponsor contact information.



## 5. Add packages and extensions to your JupyterHub environment

This is a good time to [specify your packages and extensions](QUICKSTART.md#add-packages-and-extensions) and [install those packages and extensions](QUICKSTART.md#install-packages-and-extensions), if you already know what you need.



## 6. Preserve your new project / environment

1. Add and commit the changes to your project:
    ```bash
    git add .
    git commit -m "Made changes"
    ```

1. Push the local changes to your project up to your repository on GitHub:
    ```bash
    git push
    ```

This makes the current state of your environment available to other collaborators on your GitHub repository.



## 7. Use JupyterLab

See [interacting with JupyterLab / Docker every day](QUICKSTART.md#interacting-with-jupyterlab--docker-every-day).
