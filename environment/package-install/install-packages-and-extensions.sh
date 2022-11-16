#! /bin/bash
source /home/${NB_USER}/environment/helpers.sh

# =============================================================================
# Install each extension in ${JUPYTER_EXTENSION_CSV}
# =============================================================================
function install_jupyter_extensions() {
  while IFS="" read -r LINE || [ -n "$LINE" ]
  do
    # Ignore lines in the input that begin with `#`
    [[ $LINE =~ ^#.* ]] && continue
    # Install the package
    PACKAGE=`echo -e "${LINE}" | awk -F "," '{ print $1}'`
    VERSION=`echo -e "${LINE}" | awk -F "," '{ print $2}'`
    MANUAL_INSTALL=`echo -e "${LINE}" | awk -F "," '{ print $3}'`
    log $PID "Installing $PACKAGE at $VERSION"
    if [ -z "$MANUAL_INSTALL" ]; then
      pip install --quiet --no-cache-dir "${PACKAGE}==${VERSION}"
    else
      jupyter labextension install ${PACKAGE}@${VERSION} --no-build
    fi
  done < ${JUPYTER_EXTENSION_CSV}

  # Now that we've installed the exensions using --no-build, finally build them
  log $PID "Building extensions"
  jupyter lab build --debug
}

# =============================================================================
# Install each extension in ${R_PACKAGES_CSV}
# =============================================================================
function install_r_packages() {
  while IFS="" read -r PACKAGE_URL || [ -n "$PACKAGE_URL" ]
  do
    # Ignore lines in the input that begin with `#`
    [[ $PACKAGE_URL =~ ^#.* ]] && continue
    log $PID "Installing $PACKAGE_URL"
    R -e "install.packages('${PACKAGE_URL}', repos=NULL, type='source')"
  done < ${R_PACKAGES_CSV}
}

# =============================================================================
# Install each Python package in ${PYTHON_REQUIRMENTS_TXT}
# =============================================================================
function install_python_packages() {
    log $PID "Installing ${PYTHON_REQUIRMENTS_TXT}"
  pip install --quiet --no-cache-dir --requirement ${PYTHON_REQUIRMENTS_TXT}
}

# =============================================================================
# Initialize
# =============================================================================
PID=$$ 
PACKAGE_INSTALL_CONFIG_DIR="./environment/package-install/config"
JUPYTER_EXTENSION_CSV="${PACKAGE_INSTALL_CONFIG_DIR}/jupyter-extensions.csv"
R_PACKAGES_CSV="${PACKAGE_INSTALL_CONFIG_DIR}/r-packages.csv"
PYTHON_REQUIRMENTS_TXT="${PACKAGE_INSTALL_CONFIG_DIR}/requirements.txt"

log $PID "Installing Jupyter extensions";
install_jupyter_extensions;
log $PID "Installing R packages";
install_r_packages;
log $PID "Installing Python packages";
install_python_packages;
