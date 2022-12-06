# Setting up a project

To set up a project using GitHub, you will need to clone this template to your local computer, set up your own repository on GitHub, and connect your locally cloned copy of the template to your repository.



## Prerequisites

1. You must have a GitHub account, and your GitHub account must have access to [the template repository](https://github.com/mtholyoke/docker-data-science-environment/). 
    1. If you're reading this, you're all set.
    1. If you need access to this repository, contact the [Academic Technologies department in LITS](https://lits.mtholyoke.edu/about-lits/departments/technology-infrastructure-systems-support/academic-technologies).
1. This guide assumes that you have a command-line interface that can run `bash` commands, including `git`. 
    1. Macs ship with an application called Terminal. Terminal should come with Git already installed.
    1. Windows machines will need a Git client, we recommend [Git for Windows](https://gitforwindows.org/).
    1. Most Linux distros will ship with some kind of command-line application. They also often ship with Git installed.



## Initially cloning the template to a your own project

1. On your computer, choose where you will save this project. In your command-line interface/terminal, change to the place where you will save the project (eg `~/Projects`):
    ```bash
    cd ~/Projects
    ```
1. Clone the parent template into that directory:
    ```bash
    git clone git@github.com:mtholyoke/docker-data-science-environment.git your-project-name
    ```

1. Change directory into your project:
    ```bash
    cd your-project-name
    ```

1. In your project, rename the template repository's origin for clarity. This is the connection to the template repository on GitHub:
    ```bash
    git remote rename origin template
    ```

1. Disallow pushing from your project to the template repository:
    ```bash
    git remote set-url --push template no_push
    ```

1. [Create an empty repository on Github for your project](https://github.com/new). Don't add a `README` file or `.gitignore` files when doing so.

1. Connect your local project to that new, empty repository at GitHub:
    ```bash
    git remote add origin git@github.com:you/your-project-name.git
    ```
    *Hint*: you can find what to use for `git@github.com:you/your-project-name.git` by visiting your new project repository on github.com and clicking on the green "<> Code" button. Your repository's information will be found in the text field on the "SSH" tab of the "Clone" pane.

1. Ensure that the default branch of your project is named `main`:
    ```bash
    git branch -M main
    ```
  
1. Push your branch to your new repository at GitHub:
    ```bash
    git push -u origin
    ```


### Push/pull from your repository on GitHub

1. Add and commit changes to your project:
    ```bash
    git add .
    git commit -m "Made changes"
    ```

1. Push the local changes to your project up to your repository on GitHub:
    ```bash
    git push
    ```

1. Pull from your repository on GitHub:
    ```bash
    git pull
    ```


### Pulling changes from the parent template into your project

1. Change directory into your project:
    ```bash
    cd your-project-name
    ```

1. Pull the `main` branch of the template repository into your local copy of your project:
    ```bash
    git pull --no-rebase template main
    ```

1. If there are merge conflicts, resolve them in your favorite text editor, then commit them to your project:
    ```bash
    git commit
    ```

1. Push the changes to your project up to your repository on GitHub:
    ```bash
    git push
    ```


### Pushing changes to the parent template

1. You can't. [Open an issue on the template repository](https://github.com/mtholyoke/docker-data-science-environment/issues) to inquire about global changes.
  