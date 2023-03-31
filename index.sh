#!/bin/bash

# List the scripts in the directory and display a numbered menu
index=0
for script in *.sh; do
    index=$((index+1))
    echo "$index) $script"
done

# Prompt the user to choose a script
echo "Enter the number of the script you want to run: "
read selection

# Verify that the selection is valid
if [[ "$selection" =~ ^[0-9]+$ && "$selection" -ge 1 && "$selection" -le $index ]]; then
    # Execute the selected script
    script_to_run=$(ls *.sh | sed -n "${selection}p")
    bash "$script_to_run"
else
    echo "Invalid selection. Please enter a number between 1 and $index."
fi
