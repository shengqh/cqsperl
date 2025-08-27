
#!/bin/bash
# This script calculates MD5 checksums for files in a specified folder and saves the results to raw_md5.sorted.txt.

if [ -z "$1" ]; then
    echo "Error: No argument provided"
    echo "Usage: $0 [source_folder] [target_file]"
    exit 1
fi

source_folder="$1"

if [ -z "$2" ]; then
    target_file="raw_md5.sorted.txt"
else
    target_file="$2"
fi


cd "$source_folder"
if [[ ! -s $target_file ]]; then
  echo "Calculating MD5 checksums for files in $source_folder"
  find . -type f ! -name "raw_md5.txt" ! -name "$target_file" -exec md5sum {} \; > raw_md5.txt
  sort -k2 raw_md5.txt > $target_file
  rm raw_md5.txt
  echo "MD5 checksums saved to $target_file"
else
  echo "MD5 checksums already exist in $target_file"
fi
