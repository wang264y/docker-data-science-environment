# Working with the parent template

Occasionally, the template repository may change. If it does, you can elect to ignore the changes, or you can elect to bring those changes into your project.



## Pulling changes from the parent template into your project

1. Change directory into your project:
    ```bash
    cd your-project-name
    ```

1. Pull the `main` branch of the template repository into your local copy of your project:
    ```bash
    git pull --no-rebase template main
    ```

1. If there are merge conflicts, resolve them in your favorite text editor, then commit the changes to your project:
    ```bash
    git commit
    ```

1. Push the changes to your project up to your repository on GitHub:
    ```bash
    git push -u origin
    ```



## Pushing changes to the parent template

1. You can't. [Open an issue on the template repository](https://github.com/mtholyoke/docker-data-science-environment/issues) to inquire about global changes.
