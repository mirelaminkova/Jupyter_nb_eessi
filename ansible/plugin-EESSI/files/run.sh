#!/bin/bash
set -e
if [ -f "/cvmfs/software.eessi.io/versions/2023.06/init/bash" ]; then
    source /cvmfs/software.eessi.io/versions/2023.06/init/bash
else
    echo "EESSI initialization script not found! Exiting."
    exit 1
fi

export PYTHONPATH="/opt/eessi-python/lib/python3.11/site-packages:$PYTHONPATH"
export PATH="/opt/eessi-python/bin:$PATH"
export NODE_PATH=/opt/eessi-node/lib/node_modules
export PATH=/opt/eessi-node/bin:$PATH

if [ -f "/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-001/usr/share/lmod/lmod/init/bash" ]; then
    source /cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-001/usr/share/lmod/lmod/init/bash
elif [ -f "/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-002/usr/share/lmod/lmod/init/bash" ]; then
    source /cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-002/usr/share/lmod/lmod/init/bash
else
    export PATH="/cvmfs/software.eessi.io/versions/2023.06/compat/linux/x86_64-002/usr/share/Lmod:$PATH"
fi

module load GCCcore/13.2.0
module load Python/3.11.5-GCCcore-13.2.0
module load poetry/1.6.1-GCCcore-13.2.0
module load hatch-jupyter-builder/0.9.1-GCCcore-12.3.0
module load JupyterLab/4.0.5-GCCcore-12.3.0
module load JupyterNotebook/7.0.2-GCCcore-12.3.0
module load jupyter-server/2.7.2-GCCcore-12.3.0
module load nodejs/20.9.0-GCCcore-13.2.0

#error related to rpds.rpds 
if ! python3 -c "import rpds.rpds" &>/dev/null; then
    pip install --user rpds-py
fi


echo "EESSI environment and JupyterLab module loaded."

export PATH="$HOME/.local/bin:$PATH"
exec python3 -m jupyterhub --config=/etc/jupyterhub/jupyterhub_config.py \
  --Proxy.command="/usr/local/bin/configurable-http-proxy"