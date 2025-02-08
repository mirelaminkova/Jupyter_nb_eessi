#!/bin/bash
set -e

if [[ $EESSI_CVMFS_REPO == "/cvmfs/software.eessi.io" ]] && [[ $EESSI_VERSION == "2023.06" ]]; then module load JupyterNotebook/7.0.2-GCCcore-12.3.0

else echo "Don't know which Jupyter notebook  module to load for ${EESSI_CVMFS_REPO}/versions/${EESSI_VERSION}" >&2; exit 1
fi

echo "Starting Jupyter notebook server..."
jupyter notebook --no-browser --ip=0.0.0.0 --port=8888
