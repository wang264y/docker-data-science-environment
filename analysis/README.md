# Analysis

This is where your notebooks should live.



## **TODO**
Researchers should explain any further structure or details about this area of the project here.


## File structure

These files are shared between the Docker container and your computer/the host machine.

Autosave files found `.ipynb_checkpoints/` are not available to version control in Git. You must be sure to save your work in JupyterLab prior to adding your changes to Git.


### `requirements.txt`

A classic [`requirements.txt`](https://pip.pypa.io/en/stable/reference/requirements-file-format/) file that defines what Python packages should be installed. It also can (and should) define what version of each package should be used. It may also specify JupyterLab extensions to install.


### `.gitignore`

A classic [`.gitignore`](https://git-scm.com/docs/gitignore) file for specifying what files Git should consider as not eligible for version control. This is how we exclude autosave information from our repository.

### `demo-notebooks`

These contain demo code and may be removed by the researcher.

#### `demo-notebooks/get-url-in-python.ipynb`

This notebook uses Python to retrieve a given URL (google.com), print the HTML response code, and then print the HTML contents of that URL.

#### `demo-notebooks/hello-world-in-r.ipynb`

This notebook uses R to execute a classic "hello world" program.


### `work/`

This could also hold notebooks, and was generated (I think?) automatically by JupyterLab.
