#!/bin/bash

export mybinds='/home'

if [[ -e /nobackup ]]; then
  export mybinds=$mybinds,/nobackup
fi

if [[ -e /data ]]; then
  export mybinds=$mybinds,/data
fi

if [[ -e /scratch ]]; then
  export mybinds=$mybinds,/scratch
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

if [[ -e /gpfs51 ]]; then
  export mybinds=$mybinds,/gpfs51
fi

if [[ -e /gpfs52 ]]; then
  export mybinds=$mybinds,/gpfs52
fi

#echo mybinds=$mybinds
