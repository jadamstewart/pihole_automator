#!/bin/bash

# Let's check the script is being run as root
if [[ $EUID -ne 0 ]] ; then
        echo "This script must be run as root to continue, either sudo this script or run under the root account"
        exit 1
fi

# This function just checks to see if a command is present. This is used to assume the distro we are running.
is_command() {
        local check_command="$1"

        command -v "${check_command}" > /dev/null 2>&1
}

install_brew() {
        echo "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_wget() {
        echo "Installing wget"
        brew install wget
}

# update the dhcp settings to define a static ip address
set_static_ip() {
        ip_address=$1
        ip_array=(${ip_address//./ })

        # Define the filename
        filename='/etc/dhcpcd.conf'

        # settings to append
        interface_type="interface eth0"
        static_ip="        static ip_address=${ip_address}/24"
        static_routers="        static routers=${ip_array[0]}.${ip_array[1]}.${ip_array[2]}.1"
        static_dns_servers="        static domain_name_servers=1.1.1.1 8.8.8.8"

        # Append the text by using '>>' symbol
        echo "$interface_type" >> $filename
        echo "$static_ip" >> $filename
        echo "$static_routers" >> $filename
        echo "$static_dns_servers" >> $filename
        
        #bounce the eth0 interface
        ifconfig eth0 down && echo "Sleeping for 5s..." && sleep 5 && echo "...waking up" && sudo ifconfig eth0 up
}

define_pihole_vars() {
        ip_address=$1

        # make the directory if it doesn't exist
        mkdir -p /etc/pihole/test

        filename='/etc/pihole/test/setupVars.conf'
        
        echo "PIHOLE_INTERFACE=eth0" >> $filename
        echo "IPV4_ADDRESS=${ip_address}/24" >> $filename
        echo "IPV6_ADDRESS=" >> $filename
        echo "PIHOLE_DNS_1=1.1.1.1" >> $filename
        echo "PIHOLE_DNS_2=8.8.8.8" >> $filename
        echo "QUERY_LOGGING=true" >> $filename
        echo "INSTALL_WEB_SERVER=true" >> $filename
        echo "INSTALL_WEB_INTERFACE=true" >> $filename
        echo "LIGHTTPD_ENABLED=true" >> $filename
        echo "CACHE_SIZE=10000" >> $filename
        echo "DNS_FQDN_REQUIRED=true" >> $filename
        echo "DNS_BOGUS_PRIV=true" >> $filename
        echo "DNSMASQ_LISTENING=local" >> $filename
        echo "WEBPASSWORD=0304505A52664BF4B069EDB511F97137" >> $filename
        echo "BLOCKING_ENABLED=true" >> $filename
        echo "ADMIN_EMAIL=zorrax@gmail.com" >> $filename
        echo "WEBUIBOXEDLAYOUT=boxed" >> $filename
        echo "WEBTHEME=default-light" >> $filename
}

# Main install function, this installs pihole, unbound and wget which we use to get some config files
pihole_install() {
        if is_command apt-get ; then
                tput setaf 2; echo "Running Debian based distro, continuing..."
                tput setaf 2; echo "PiHole installation beginning..."
                # Standard pihole install
                #curl -sSL https://install.pi-hole.net | bash
                # Install pihole non-interactive
                #curl -L https://install.pi-hole.net | bash /dev/stdin --unattended
        else
                tput setaf 1; echo "This script has been written to run on Debian based distros. Quiting..."
                exit 1
        fi
}


read -p "What ip address should this use: " ip_address
#TODO: brew wants to be run as NOT root, but other stuff needs root
# Since pi comes with wget already, we will skip this for now
#install_brew
#install_wget
set_static_ip "$ip_address"
define_pihole_vars "$ip_address"
pihole_install
