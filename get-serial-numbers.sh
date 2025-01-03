#!/bin/bash

# List of possible drive endpoints
DRIVES=$(ls /dev/sata? /dev/nvme?n1 2>/dev/null)

# Iterate through each drive and get the serial number
for DRIVE in $DRIVES; do
    if [[ $DRIVE == /dev/nvme* ]]; then
        SERIAL=$(sudo nvme id-ctrl $DRIVE | grep 'sn' | awk '{print $3}')
    else
        SERIAL=$(sudo smartctl -i $DRIVE | grep 'Serial Number' | awk '{print $3}')
        if [ -z "$SERIAL" ]; then
            SERIAL=$(sudo smartctl -a $DRIVE | grep 'Serial number' | awk '{print $3}')
        fi
    fi
    if [ ! -z "$SERIAL" ]; then
        echo "Drive: $DRIVE, Serial Number: $SERIAL"
    else
        echo "Drive: $DRIVE, Serial Number: Not Available"
    fi
done
