#!/bin/bash

source_file="darkKnight.json"  # Replace with your source JSON file name

# Loop through all files in the current directory
for existing_file in *; do
    # Check if the item is a file and not the source file itself
    if [ -f "$existing_file" ] && [ "$existing_file" != "$source_file" ]; then
        # Extract the base name of the existing file
        base_name=$(basename "$existing_file" .json)
        # Copy the content of the source JSON file and save as a new JSON file with the existing file's name
        cat "$source_file" > "$base_name.json"
        echo "Copied to copy_$base_name.json"
    fi
done
