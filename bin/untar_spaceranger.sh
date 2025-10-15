
#!/bin/bash

if [ -z "$1" ]; then
    echo "Error: No argument provided"
    echo "Usage: $0 [source_folder]"
    exit 1
fi

source_folder="$1"

cd "$source_folder"

if [[ -s segmented_outputs.tar.gz ]]; then
  if [[ -s segmented_outputs/filtered_feature_cell_matrix.h5 ]]; then
    echo "segmented_outputs has already been extracted. "
    rm -f segmented_outputs.tar.gz
  else
    mkdir -p segmented_outputs
    echo "Extracting segmented_outputs.tar.gz"
    tar -xzvf segmented_outputs.tar.gz -C segmented_outputs

    status=$?
    if [ $status -ne 0 ]; then
      echo "Error extracting segmented_outputs.tar.gz"
      exit $status
    else
      echo "Extracting segmented_outputs.tar.gz succeeded, delete the segmented_outputs.tar.gz file."
      rm -f segmented_outputs.tar.gz
    fi
  fi
else
  if [[ ! -s segmented_outputs/filtered_feature_cell_matrix.h5 ]]; then
    echo "Error: segmented_outputs.tar.gz not found and segmented_outputs/filtered_feature_cell_matrix.h5 not exist. "
    exit 1
  else
    echo "segmented_outputs.tar.gz not found, but segmented_outputs/filtered_feature_cell_matrix.h5 exist. "
  fi
fi

if [[ -s segmented_outputs/cloupe.cloupe ]]; then
  rm -f cloupe_cell.cloupe
  ln -s segmented_outputs/cloupe.cloupe cloupe_cell.cloupe
fi

if [[ ! -s segmented_outputs/spatial/tissue_lowres_image.png ]]; then
  cd segmented_outputs/spatial/
  ln -s ../../spatial/tissue_lowres_image.png tissue_lowres_image.png 
  ln -s ../../spatial/tissue_hires_image.png tissue_hires_image.png 
  cd ../../
fi

if [[ -s binned_outputs.tar.gz ]]; then
  if [[ -s binned_outputs/square_016um/filtered_feature_bc_matrix.h5 ]]; then
    echo "binned_outputs has already been extracted. "
    rm -f binned_outputs.tar.gz
  else
    mkdir -p binned_outputs
    echo "Extracting binned_outputs.tar.gz"
    tar -xzvf binned_outputs.tar.gz -C binned_outputs
    status=$?
    if [ $status -ne 0 ]; then
      echo "Error extracting binned_outputs.tar.gz"
      exit $status
    else
      echo "Extracting binned_outputs.tar.gz succeeded, delete the binned_outputs.tar.gz file."
      rm -f binned_outputs.tar.gz
    fi
  fi
else
  if [[ ! -s binned_outputs/square_016um/filtered_feature_bc_matrix.h5 ]]; then
    echo "Error: binned_outputs.tar.gz not found and binned_outputs/square_016um/filtered_feature_bc_matrix.h5 not exist. "
    exit 1
  else
    echo "binned_outputs.tar.gz not found, but binned_outputs/square_016um/filtered_feature_bc_matrix.h5 exist. "
  fi
fi

if [[ -s binned_outputs/square_008um/cloupe.cloupe ]]; then
  rm -f cloupe_008um.cloupe
  ln -s binned_outputs/square_008um/cloupe.cloupe cloupe_008um.cloupe
fi

if [[ ! -s binned_outputs/square_008um/spatial/tissue_lowres_image.png ]]; then
  cd binned_outputs/square_008um/spatial/
  ln -s ../../../spatial/tissue_lowres_image.png tissue_lowres_image.png 
  ln -s ../../../spatial/tissue_hires_image.png tissue_hires_image.png 
  cd ../../../
fi

if [[ -s spatial.tar.gz ]]; then
  if [[ -s spatial/detected_tissue_image.jpg ]]; then
    echo "spatial has already been extracted. "
    rm -f spatial.tar.gz
  else
    mkdir -p spatial
    echo "Extracting spatial.tar.gz"
    tar -xzvf spatial.tar.gz -C spatial

    status=$?
    if [ $status -ne 0 ]; then
      echo "Error extracting spatial.tar.gz"
      exit $status
    else
      echo "Extracting spatial.tar.gz succeeded, delete the spatial.tar.gz file."
      rm -f spatial.tar.gz
    fi
  fi
else
  if [[ ! -s spatial/detected_tissue_image.jpg ]]; then
    echo "Error: spatial.tar.gz not found and spatial/detected_tissue_image.jpg not exist. "
    exit 1
  else
    echo "spatial.tar.gz not found, but spatial/detected_tissue_image.jpg exist. "
  fi
fi
