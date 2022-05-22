#! /usr/bin/bash

BASEDIR=$( dirname $0 )

function install_dependencies(){
    echo "Installing Dependecies ..."
    sleep 1s

    packages=$(tr $'\n' ' ' < $BASEDIR/packages)
    sudo pacman -Sy $packages

    if [[ $? != 0 ]]
    then
        echo "An error Occured installing required pacakages"
        exit -2
    fi

    echo "Installing fonts ..."
    sleep 0.3s
    mkdir -p "$HOME/.fonts"
    cp "$BASEDIR/fonts/"* "$HOME/.fonts"
}

function setup_services(){
    echo "Setting up services ..."
    sleep 1s
    sudo rm /etc/systemd/system/display-manager.service 2> /dev/null
    sudo systemctl enable --now bluetooth NetworkManager lightdm dhcpcd wpa_supplicant
}

function setup_configurations(){
    echo "Setting Up configurations ..."
    sleep 1s

    echo "Setting up bluetooth configuration"
    sleep 0.3s
    sudo sed -ri 's/#(AutoEnable)=false/\1=true/' /etc/bluetooth/main.conf

    echo "setting up i3 blocks configuration"
    sleep 0.3s
    mkdir -p "$HOME/.i3"
    cp -r "$BASEDIR/scripts" "$HOME/.i3"
    sudo cp "$BASEDIR/i3blocks.conf" "/etc/"

    echo "setting up i3 configuration file"
    sleep 0.3s
    mkdir -p "$HOME/.config/i3"
    cp "$BASEDIR/config" "$HOME/.config/i3"

    echo "setting up touchpad"
    sleep 0.3s
    sudo cp "$BASEDIR/touchpad/30-touchpad.conf" "/etc/X11/xorg.conf.d/"

}
function main(){
    if [[ $UID == 0 ]]
    then
       echo "Warning: This will install desktop environment configuration for only root user"
       echo "If this is not what you want please run script as normal user"
       sleep 2s
    fi

    install_dependencies
    setup_services
    setup_configurations
    echo "Desktop Environment installed successfully."

}

main
