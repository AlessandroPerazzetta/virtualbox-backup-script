#!/bin/bash

NOW=$(date +"%Y%m%d-%H%M")

# Declare default vm filter list    
vm_filter="list"    
    
# Declare an array of string with vm list from command    
declare -a vm_list=("vmname1" "vmname2" "vmname3")    
    
Help()    
{    
   # Display Help    
   echo "VirtualBox Backup Script"    
   echo    
   echo "Syntax: vbox-backup-vms.sh [-a|h]"    
   echo "options:"    
   echo "a     Set VM list backup to all"    
   echo "h     Print this Help."    
   echo    
}    
    
# Get the options    
while getopts ":ha" option; do    
   case $option in    
      h) # display Help    
         Help    
         exit;;    
      a) # export all vm    
         vm_filter="all";;    
     \?) # Invalid option    
         echo "Error: Invalid option"    
         exit;;    
   esac    
done    
    
if [ $vm_filter == "all" ]; then    
    echo "Virtual Machines filter set to: all"    
    vm_list=( $(vboxmanage list vms | awk -F' ' '{ print $1 }'| sed 's/"//g'))    
else    
    echo "Virtual Machines filter set to: list"    
fi    

mkdir -p ${NOW}

# Iterate the vm list string array using for loop    
for vm in ${vm_list[@]}; do    
    if vboxmanage showvminfo $vm --machinereadable | egrep '^VMState="running"$' > /dev/null; then    
        echo "Poweroff VM: $vm"    
        vboxmanage controlvm $vm poweroff    
    fi    
    echo "Backup VM: $vm into $vm.ovf"    
    vboxmanage export $vm -o $NOW/$vm.ova --ovf20 --options manifest    
done                                                                                         
