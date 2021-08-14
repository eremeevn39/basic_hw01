#!/bin/bash

status="$(sestatus)"
status2="$(echo  "${status}" | cut -d' ' -f3- | head -n 1 | sed s/' '//g)"
ge="$(getenforce)"
myid="$(id | cut -d'=' -f2 | cut -d'(' -f1 )"

if [ "$myid" = "0" ]
then

if [ "$status2" = "disabled" ]
then echo "Now SELINUX is: disabled"
echo "You can enable SELINUX, only if you change the config file and reboot after this"
else echo "Now SELINUX is: enabled and state is $ge"
if [ "$ge" = "Enforcing" ]
then
echo "If you want to change SELINUX state to \"Permissive\", type \"0\""
elif [ "$ge" = "Permissive" ]
then
echo "If you want to change SELINUX state to \"Enforcing\", type \"1\""
fi
fi

config=$(cat /etc/selinux/config | cut -d' ' -f1 | grep "SELINUX=" | cut -d'=' -f2)

echo ""

echo "SELINIX state in the config file is: $config"
if [ "$config" = "disabled" ]
then echo "If you want to enable SELINUX and change state to \"enforcing\" in the config file, type \"2\""
echo "If you want to enable SELINUX and change state to \"permissive\" in the config file, type \"3\"."
elif [ "$config" = "enforcing" ]
then echo "If you want to change state to \"disabled\" in the config file, type \"4\""
echo "If you want to change state to \"permissive\" in the config file, type \"5\"."
elif [ "$config" = "permissive" ]
then echo "If you want to change state to \"disabled\" in the config file, type \"6\""
echo "If you want to change state to \"enforcing\" in the config file, type \"7\"."
fi

echo ""

read -p 'Choose the action and type the number: ' var1
if [ "$var1" = "0" ]
then
setenforce 0
echo "SELINUX state is: Permissive"
elif [ "$var1" = "1" ]
then
setenforce 1 
echo "SELINUX state is: Enforcing"
elif [ "$var1" = "2" ]
then
sed -i 's/=disabled/=enforcing/' /etc/selinux/config
echo "You changed the state of SELINUX in the config to Enforcing. Now you need to reboot the system"
elif [ "$var1" = "3" ]
then
sed -i 's/=disabled/=permissive/' /etc/selinux/config
echo "You changed the state of SELINUX in the config to Permissive. Now you need to reboot the system"
elif [ "$var1" = "4" ]
then
sed -i 's/=enforcing/=disabled/' /etc/selinux/config
echo "You changed the state of SELINUX in the config to Disabled. Now you need to reboot the system"
elif [ "$var1" = "5" ]
then
sed -i 's/=enforcing/=permissive/' /etc/selinux/config
echo "You changed the state of SELINUX in the config to Permissive. Now you need to reboot the system"
elif [ "$var1" = "6" ]
then
sed -i 's/=permissive/=disabled/' /etc/selinux/config
echo "You changed the state of SELINUX in the config to Disabled. Now you need to reboot the system"
elif [ "$var1" = "7" ]
then
sed -i 's/=permissive/=enforcing/' /etc/selinux/config
echo "You changed the state of SELINUX in the config to Enforcing. Now you need to reboot the system"
else
echo "Please reload the script and type right number"
fi

else
echo "Please, run this script with sudo or using root account. Thank you"
fi
