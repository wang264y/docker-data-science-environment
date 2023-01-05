#! /bin/bash

# This script knows how to interpret the jupyter-extensions.csv file and
# installs the packages as specified.

while IFS="" read -r LINE || [ -n "$LINE" ]; do
  # Ignore lines in the input that begin with `#`
  [[ $LINE =~ ^#.* ]] && continue
  # Install the package
  PACKAGE=`echo -e "${LINE}" | awk -F "," '{ print $1}'`
  VERSION=`echo -e "${LINE}" | awk -F "," '{ print $2}'`
  MANUAL_INSTALL=`echo -e "${LINE}" | awk -F "," '{ print $3}'`
  echo "Installing $PACKAGE at $VERSION"
  if [ -z "$MANUAL_INSTALL" ]; then
    pip install --quiet --no-cache-dir "${PACKAGE}==${VERSION}"
  else
    jupyter labextension install ${PACKAGE}@${VERSION}
  fi
done < jupyter-extensions.csv
