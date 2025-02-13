#!/bin/bash
set -e

# Load EESSI environment
if [ -f "/cvmfs/software.eessi.io/versions/2023.06/init/bash" ]; then
    source /cvmfs/software.eessi.io/versions/2023.06/init/bash
else
    echo "EESSI initialization script not found! Exiting."
    exit 1
fi

# Locate and initialize Lmod
if [ -f "/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-001/usr/share/lmod/lmod/init/bash" ]; then
    source /cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-001/usr/share/lmod/lmod/init/bash
elif [ -f "/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-002/usr/share/lmod/lmod/init/bash" ]; then
    source /cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-002/usr/share/lmod/lmod/init/bash
else
    export PATH="/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-002/usr/share/Lmod:$PATH"
fi

# Load necessary EESSI modules
module load GCCcore/13.2.0
module load JupyterNotebook/7.0.2-GCCcore-12.3.0
module load jupyter-server/2.7.2-GCCcore-12.3.0
module load nodejs/20.9.0-GCCcore-13.2.0

# Create a virtual environment for JupyterHub
export JHUB_ENV="/home/$USER/.jupyterhub-venv"

if [ ! -d "$JHUB_ENV" ]; then
    echo "Creating JupyterHub virtual environment..."
    python3 -m venv "$JHUB_ENV"
    source "$JHUB_ENV/bin/activate"
    pip install --upgrade pip
    pip install jupyterhub
    deactivate
fi

# Activate the virtual environment
source "$JHUB_ENV/bin/activate"

# Verify JupyterHub is installed
if ! command -v jupyterhub &> /dev/null; then
    echo "ERROR: JupyterHub installation failed!"
    exit 1
fi

# Start JupyterHub
nohup jupyterhub --no-browser --ip=0.0.0.0 --port=8000 > /opt/jupyterhub.log 2>&1 &
echo "JupyterHub started successfully!"
