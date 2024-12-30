#!/bin/bash

#ARCHITECTURE
ARCH=$(uname -a)

#CPU PHYSICAL
PCPU=$(grep "physical id" /proc/cpuinfo |sort -u | wc -l)

#vCPU
VCPU=$(grep "processor" /proc/cpuinfo | wc -l)

#RAM/Memory usage
RAM_TOTAL=$(free --mega | awk '$1 == "Mem:" {print $2}')
RAM_USE=$(free --mega | awk '$1 == "Mem:" {print $3}')
RAM_PERCENT=$(free --mega | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

#Disk Memory
DISK=$(df -m --total | grep total | awk '{printf "%d/%dGb (%s)\n", $3,$2/1024,$5}')

#CPU usage
CPU=$(mpstat | tail -1 | awk '{printf "%.1f%%", 100 - $13}')

#last reboot
BOOT=$(who -b | awk '{print $3 " " $4}')

#LVM ACTIVE OR NOT
LVM=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

#TCP CONNECTION
TCP=$(ss -ta | grep ESTAB | wc -l)

#Number of users
USR=$(users | wc -w)

#Ip Adress && Mac Adress
Ip=$(hostname -I | awk '{print $1}')
MAC=$(ip link show enp0s3 | awk ' /ether/ {print $2}')

#NUMBER OF COMMAND EXECUTED WITH SUDO
SUDO=$(journalctl _COMM=sudo -q | grep COMMAND | wc -l)

wall "	Architecture: $ARCH
	CPU physical: $PCPU
	vCPU: $VCPU
	Memory Usage: $RAM_USE/${RAM_TOTAL}MB ($RAM_PERCENT%)
	Disk Usage: $DISK
	CPU load: $CPU
	Last boot: $BOOT
	LVM use: $LVM
	Connections TCP: $TCP ESTABLISHED
	User log: $USR
	Network: IP $Ip ($MAC)
	Sudo: $SUDO cmd" 


