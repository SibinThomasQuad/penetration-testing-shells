#!/bin/bash

# Get the IDs of the input devices
ids=$(xinput list | grep 'slave  keyboard' | awk -F'=' '{print $2}' | awk '{print $1}')

# Loop through each ID and disable the device
for id in $ids
do
  xinput disable $id
done
