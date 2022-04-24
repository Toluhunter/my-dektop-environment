#! /usr/bin/bash

BASEDIR=$( dirname $0 )
function install_dependencies(){
    echo "Installing Dependecies ..."
    sleep 1s

    packages=$(tr $'\n' ' ' < $BASEDIR/packages)
    pacman -Sy $packages

    if [[ $? != 0 ]]
    then
        echo "An error Occured installing required pacakages"
        exit -2
    fi

    echo "Installing fonts ..."
    sleep 0.3s
    mkdir ~/.fonts
    cp BASEDIR/fonts/* ~/.fonts
}

function setup_services(){
    echo "Setting up services ..."
    sleep 1s
    rm /etc/systemd/system/display-manager.service 2> /dev/null
    systemctl enable --now bluetooth NetworkManager lightdm
}

function setup_configurations(){
    echo "Setting Up configurations ..."
    sleep 1s

    echo "Setting up bluetooth configuration"
    sleep 0.3s
    sed -ri 's/(AutoEnable)=false/\1=true/' /etc/bluetooth/main.conf

    echo "setting up i3 blocks configuration"
    sleep 0.3s
    mkdir ~/.i3
    cp -r BASEDIR/scripts ~/.i3
    cp BASEDIR/i3blocks.conf /etc/

    echo "setting up i3 configuration file"
    sleep 0.3s
    mkdir -p ~/.config/i3
    cp BASEDIR/config ~/.config/i3
}
function main(){
    if [[ $UID != 0 ]]
    then
        echo "Please run this script as root"
        exit -1
    fi

    install_dependencies
    setup_services
    setup_configurations
    echo "Desktop Environment installed successfully."

}

main