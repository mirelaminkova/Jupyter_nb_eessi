#!/bin/bash
set -e

# Optional delay to ensure CVMFS is mounted
# sleep 10

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
module load hatch-jupyter-builder/0.9.1-GCCcore-12.3.0
module load JupyterLab/4.0.5-GCCcore-12.3.0
module load JupyterNotebook/7.0.2-GCCcore-12.3.0
module load jupyter-server/2.7.2-GCCcore-12.3.0
module load nodejs/20.9.0-GCCcore-13.2.0

echo "EESSI environment and JupyterLab module loaded."

# Start JupyterLab via the jupyterhub binary (configured to launch JupyterLab)
exec /usr/local/bin/jupyterhub --config=/etc/jupyterhub/jupyterhub_config.py
