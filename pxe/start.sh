#! /bin/bash

set -e

myIF=$(ip addr show | awk '/inet.*brd/{print $NF}' | head -n1)
myIP=$(ip addr show dev ${myIF} | awk -F '[ /]+' '/global/ {print $3}') 
mySUBNET=$(echo $myIP | cut -d '.' -f 1,2,3)

echo "Starting DHCP+TFTP server ... (myIP:${myIP}, mySUBNET:${mySUBNET})"
dnsmasq --interface=${myIF} \
    --dhcp-range=$mySUBNET.101,$mySUBNET.199,255.255.255.0,1h \
    --dhcp-boot=pxelinux.0,pxeserver,$myIP \
    --pxe-service=x86PC,"Install Linux",pxelinux \
    --enable-tftp --tftp-root=/tftp/ --no-daemon \
    --conf-file=/etc/dnsmasq.conf

# Let's be honest: I don't know if the --pxe-service option is necessary.
# The iPXE loader in QEMU boots without it.  But I know how some PXE ROMs
# can be picky, so I decided to leave it, since it shouldn't hurt.
