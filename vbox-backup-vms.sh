#!/bin/bash
# Declare an array of string with vm list
declare -a vm_list=("vmname1" "vmname2" "vmname3")
# Declare an array of string with vm list from command
#vm_list=( $(vboxmanage list vms | awk -F' ' '{ print $1 }'| sed 's/"//g')) 
# Iterate the vm list string array using for loop
for val in ${vm_list[@]}; do
   echo "Backup VM: $val into $val.ovf"
   vboxmanage export $val -o $val.ova --ovf20 --options manifest
done
