#! /bin/bash
source /home/${NB_USER}/environment/helpers.sh

# =============================================================================
# Helper that 
#   - Returns 0 if the MD5 hash in the lockfile matches the MD5 hash of the 
#     current file
#   - Returns 1 if the lockfile does not exist
#   - Returns 2 if the M5 hashes don't match
# =============================================================================
function checkMD5Sum() {
  LOCK_FILE=$1
  FILE=$2

  if [ ! -f $LOCK_FILE ]; then 
    return 1
  fi

  PREV_MD5SUM=`cat ${LOCK_FILE}`
  CURRENT_MD5SUM=`md5sum ${FILE}`
  if [[ $CURRENT_MD5SUM == $PREV_MD5SUM ]]; then
    return 0
  else
    return 2
  fi
}

# =============================================================================
# Install each extension in ${JUPYTER_EXTENSION_CSV}
# =============================================================================
function install_jupyter_extensions() {
  checkMD5Sum ${JUPYTER_EXTENSION_CSV_MD5_LOCK_FILE} ${JUPYTER_EXTENSION_CSV}
  if [ $? == 0 ]; then
    log $PID "${JUPYTER_EXTENSION_CSV} has not changed since last run. Delete ${JUPYTER_EXTENSION_CSV_MD5_LOCK_FILE} to force install attempt."
    return;
  fi

  # Do the processing
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

  # Create lockfile for the current version of these requirements
  md5sum ${JUPYTER_EXTENSION_CSV} > ${JUPYTER_EXTENSION_CSV_MD5_LOCK_FILE}
}

# =============================================================================
# Install each extension in ${R_PACKAGES_CSV}
# =============================================================================
function install_r_packages() {
  checkMD5Sum ${R_PACKAGES_CSV_MD5_LOCK_FILE} ${R_PACKAGES_CSV}
  if [ $? == 0 ]; then
    log $PID "${R_PACKAGES_CSV} has not changed since last run. Delete ${R_PACKAGES_CSV_MD5_LOCK_FILE} to force install attempt."
    return;
  fi

  # Do the processing
  while IFS="" read -r PACKAGE_URL || [ -n "$PACKAGE_URL" ]
  do
    # Ignore lines in the input that begin with `#`
    [[ $PACKAGE_URL =~ ^#.* ]] && continue
    log $PID "Installing $PACKAGE_URL"
    R -e "install.packages('${PACKAGE_URL}', repos=NULL, type='source')"
  done < ${R_PACKAGES_CSV}

  # Create lockfile for the current version of these requirements
  md5sum ${R_PACKAGES_CSV} > ${R_PACKAGES_CSV_MD5_LOCK_FILE}
}

# =============================================================================
# Install each Python package in ${PYTHON_REQUIRMENTS_TXT}
# =============================================================================
function install_python_packages() {
  checkMD5Sum ${PYTHON_REQUIRMENTS_TXT_MD5_LOCK_FILE} ${PYTHON_REQUIRMENTS_TXT}
  if [ $? == 0 ]; then
    log $PID "${PYTHON_REQUIRMENTS_TXT} has not changed since last run. Delete ${PYTHON_REQUIRMENTS_TXT_MD5_LOCK_FILE} to force install attempt."
    return;
  fi

  # Do the processing

  log $PID "Installing ${PYTHON_REQUIRMENTS_TXT}"
  pip install --quiet --no-cache-dir --requirement ${PYTHON_REQUIRMENTS_TXT}

  # Create lockfile for the current version of these requirements
  md5sum ${PYTHON_REQUIRMENTS_TXT} > ${PYTHON_REQUIRMENTS_TXT_MD5_LOCK_FILE}
}

# =============================================================================
# Initialize
# =============================================================================
PID=$$ 
PACKAGE_INSTALL_CONFIG_DIR="./environment/package-install/config"

JUPYTER_EXTENSION_CSV="${PACKAGE_INSTALL_CONFIG_DIR}/jupyter-extensions.csv"
JUPYTER_EXTENSION_CSV_MD5_LOCK_FILE="${PACKAGE_INSTALL_CONFIG_DIR}/.jupyter-extensions.csv.md5"

R_PACKAGES_CSV="${PACKAGE_INSTALL_CONFIG_DIR}/r-packages.csv"
R_PACKAGES_CSV_MD5_LOCK_FILE="${PACKAGE_INSTALL_CONFIG_DIR}/.r-packages.csv.md5"

PYTHON_REQUIRMENTS_TXT="${PACKAGE_INSTALL_CONFIG_DIR}/requirements.txt"
PYTHON_REQUIRMENTS_TXT_MD5_LOCK_FILE="${PACKAGE_INSTALL_CONFIG_DIR}/.requirements.txt.md5"



log $PID "Installing Jupyter extensions";
install_jupyter_extensions;
log $PID "Installing R packages";
install_r_packages;
log $PID "Installing Python packages";
install_python_packages;
