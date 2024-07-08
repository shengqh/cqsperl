#!/bin/bash

export mybinds='/home,/tmp'

if [[ -e /accre ]]; then
  export mybinds=$mybinds,/accre
fi

if [[ -e /afs ]]; then
  export mybinds=$mybinds,/afs
fi

if [[ -e /panfs ]]; then
  export mybinds=$mybinds,/panfs
fi

if [[ -e /nobackup ]]; then
  export mybinds=$mybinds,/nobackup
fi

if [[ -e /data ]]; then
  export mybinds=$mybinds,/data
fi

if [[ -e /workspace ]]; then
  export mybinds=$mybinds,/workspace
fi

if [[ -e /data1 ]]; then
  export mybinds=$mybinds,/data1
fi

if [[ -e /dors ]]; then
  export mybinds=$mybinds,/dors
fi

# if [[ -e /gpfs51 ]]; then
#   export mybinds=$mybinds,/gpfs51
# fi

# if [[ -e /gpfs52 ]]; then
#   export mybinds=$mybinds,/gpfs52
# fi

# if [[ -e /gpfs23 ]]; then
#   export mybinds=$mybinds,/gpfs23
# fi

#echo mybinds=$mybinds

