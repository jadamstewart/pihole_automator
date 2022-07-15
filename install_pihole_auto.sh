#!/bin/bash

# Let's check the script is being run as root

if [[ $EUID -ne 0 ]] ; then
        echo "This script must be run as root to continue, either sudo this script or run under the root 
account"
        exit 1
fi


# This function just checks to see if a command is present. This is used to assume the distro we are running.
is_command() {
        local check_command="$1"

        command -v "${check_command}" > /dev/null 2>&1
}


# update the dhcp settings to define a static ip address
set_static_ip() {
        # Define the filename
        filename='/etc/dhcpcd.conf'

        # settings to append
        interface_type='interface eth0'
        static_ip='        static ip_address=192.168.42.4/24'
        static_gateway='        static routers=192.168.42.1'
        static_dns_servers='        static domain_name_servers=8.8.8.8 8.8.4.4'

        # Append the text by using '>>' symbol
        echo $interface_type >> $filename
        echo $static_ip >> $filename
        echo $static_gateway >> $filename
        echo $static_dns_servers >> $filename
        
        #TODO: probably need to reboot after this, but maybe I can just restart a process?
}

# Main install function, this installs pihole, unbound and wget which we use to get some config files
pihole_install() {
        if is_command apt-get ; then
                tput setaf 2; echo "Running Debian based distro, continuing..."
                tput setaf 2; echo "PiHole installation beginning..."
                #curl -sSL https://install.pi-hole.net | bash
        else
                tput setaf 1; echo "This script has been written to run on Debian based distros. Quiting..."
                exit 1
        fi
}

set_static_ip
pihole_install
