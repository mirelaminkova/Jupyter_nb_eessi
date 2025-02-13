#!/bin/bash
set -e

# Load EESSI environment correctly
if [ -f "/cvmfs/software.eessi.io/versions/2023.06/init/bash" ]; then
    source /cvmfs/software.eessi.io/versions/2023.06/init/bash
else
    echo "EESSI initialization script not found! Exiting."
    exit 1
fi

# Locate the Lmod module initialization script
if [ -f "/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-001/usr/share/lmod/lmod/init/bash" ]; then
    echo "Sourcing Lmod initialization script..."
    source /cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-001/usr/share/lmod/lmod/init/bash
elif [ -f "/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-002/usr/share/lmod/lmod/init/bash" ]; then
    echo "Sourcing Lmod initialization script..."
    source /cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-002/usr/share/lmod/lmod/init/bash
else
    echo "Lmod init script not found! Manually setting paths..."
    export PATH="/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-001/usr/share/Lmod:$PATH"
    export PATH="/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-002/usr/share/Lmod:$PATH"
fi

# Verify module command
if ! command -v module &> /dev/null; then
    echo "ERROR: 'module' command still not found! Exiting."
    exit 1
fi

module --version

# Ensure MODULEPATH is set
export MODULEPATH="/cvmfs/software.eessi.io/versions/2023.06/software/linux/x86_64/amd/zen2/modules/all:$MODULEPATH"

# Load required modules
module load GCCcore/13.2.0 || { echo "Failed to load GCC"; exit 1; }
module load JupyterNotebook/7.0.2-GCCcore-12.3.0 || { echo "Failed to load JupyterNotebook"; exit 1; }
module load jupyter-server/2.7.2-GCCcore-12.3.0 || { echo "Failed to load jupyter-server"; exit 1; }
module load nodejs/20.9.0-GCCcore-13.2.0 || { echo "Failed to load nodejs"; exit 1; }

# Debug: Verify modules loaded
module list

# Check JupyterHub availability
which jupyterhub || { echo "JupyterHub not found after module load"; exit 1; }

# Run JupyterHub and capture logs
nohup jupyterhub --no-browser --ip=0.0.0.0 --port=8000 > /opt/jupyterhub.log 2>&1 &
echo "JupyterHub started successfully!"
