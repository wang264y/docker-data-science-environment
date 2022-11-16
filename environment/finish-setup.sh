#! bin/bash
source /home/${NB_USER}/environment/helpers.sh
PID=$$ 

# Get the Jupyter server config in place
log $PID "Enabling custom Jupyter config"
mkdir -p /home/${NB_USER}/.jupyter/
cp /home/${NB_USER}/environment/jupyter_server_config.py /home/${NB_USER}/.jupyter/jupyter_server_config.py

# Get data linked into where you can see it in the Jupyter UI
log $PID "Make 'data/' available to Jupyter UI"
if [ ! -d "/home/${NB_USER}/analysis/data" ]; then
  ln -s /home/${NB_USER}/data /home/${NB_USER}/analysis/
fi

# Install packages and extensions
log $PID "Installing custom packages and extensions"
/home/${NB_USER}/environment/package-install/install-packages-and-extensions.sh

# Fix permissions
log $PID "Fixing permissions"
fix-permissions "${CONDA_DIR}" && fix-permissions "/home/${NB_USER}"

# Start Jupyter Lab
# exec /usr/local/bin/start.sh jupyter lab ${NOTEBOOK_ARGS} "$@"
log $PID "Starting Jupyter"
exec /usr/local/bin/start-notebook.sh
