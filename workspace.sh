#!/bin/sh

function install_yay() {
    [ -f /usr/bin/yay ] && { echo "Yay already installed yay -- skipping"; return 0; }

    echo "( Installing yay )"
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin && \
    cd /tmp/yay-bin && makepkg -si || \
        { echo "[ Failed to install yay ]"; exit 1; }
    cd && rm -rf /tmp/yay-bin
}

function configure_git() {
    echo "( Configuring git )"
    git config --global user.email "ivansilva.me@gmail.com"
    git config --global user.name "sjlwa"

    sed -i '/^Host github\.com/,/^$/d' ~/.ssh/config
    {
      echo -e "\n"
      echo "Host github.com"
      echo "  Hostname github.com"
      echo "  User git"
      echo "  IdentityFile ~/.ssh/github-key"
    } >> ~/.ssh/config

}

function install_essential_packages() {
    echo "( Installing essential packages )"
	sudo pacman -S --needed \
         man-db man-pages \
         bluez \
         jq unzip git base-devel \
         vlc mpv xclip \
         pacman-contrib

    [ $? -ne 0 ] && { echo "[ Failed to install essential packages ]"; exit 1; }

    configure_git
    install_yay || exit 1

    sudo systemctl enable bluetooth
    sudo systemctl start bluetooth

    sudo bash -c "echo 'loop-file=inf' > /etc/mpv/mpv.conf"
}

function configure_windows() {
    echo "( Configuring window manager settings )"
    xfconf-query -c xfwm4 -p /general/snap_to_border -s true
    xfconf-query -c xfwm4 -p /general/snap_to_border -s true
	xfconf-query -c xsettings -p /Net/ThemeName -s "Adwaita-dark"

    sudo pacman -S --needed rofi || { echo "Failed to download rofi"; exit 1; }
    mkdir ~/.config/rofi
    ln -s $(pwd)/rofi.rasi ~/.config/rofi/config.rasi

	xfconf-query -c xfce4-keyboard-shortcuts \
                 --create -p "/commands/custom/Super_L" \
                 -t string -s "rofi -show drun" || \
        { echo "[ Failed to configure rofi ]"; exit 1; }

    echo 'export GTK_THEME=Adwaita:dark' >> ~/.zprofile
}

function install_blesh() {
    # install ble.sh syntax highlighting and autocompletions for bash
    wget https://github.com/akinomyoga/ble.sh/releases/download/v0.4.0-devel3/ble-0.4.0-devel3.tar.xz \
         -O /tmp/blesh.tar.xz && \
        mkdir -p ~/.local/share/blesh && \
        tar xJf /tmp/blesh.tar.xz -C ~/.local/share/blesh && \
        echo 'source ~/.local/share/blesh/ble-0.4.0-devel3/ble.sh ' >> ~/.bashrc
}

function configure_terminal() {
    echo "( Configuring terminal settings )"
	xfconf-query -c xfce4-terminal -p /font-name -s "Iosevka 16"
	xfconf-query -c xfce4-terminal -p /font-use-system -s "true"
	xfconf-query -c xfce4-terminal -p /misc-show-unsafe-paste-dialog -s "false"
	xfconf-query -c xfce4-terminal -p /misc-menubar-default -s "false"
	xfconf-query -c xfce4-terminal -p /misc-slim-tabs -s "true"
    xfconf-query -c xfce4-keyboard-shortcuts \
                 --create -p "/commands/custom/<Super>t" \
                 -t string -s "xfce4-terminal"
}

function configure_bt_keyboard() {
    [ -f /usr/bin/obinskit ] && { exit 0; }
    echo "( Configuring Bluetooth keyboard )"
    download_path=/tmp/obinskit.tar.gz
    wget https://s3.hexcore.xyz/occ/linux/tar/ObinsKit_1.2.11_x64.tar.gz \
         -O $download_path && \
        mkdir -p ~/.local/share/obins-kit && \
        tar -xvf $download_path -C ~/.local/share/obins-kit && \
        ln -s ~/.local/share/obins-kit/*/obinskit /usr/bin/obinskit || \
            { echo "[ Failed to create symlink for obinskit ]"; exit 1; }
    rm $download_path
}

function configure_virtualization() {
    echo "( Configuring virtualization )"
    sudo pacman -S --needed dnsmasq openbsd-netcat qemu libvirt || \
        { echo "[ Failed to install virtualization packages ]"; exit 1; }

    yay -S --needed openbsd-netcat
    sudo usermod -aG libvirt $USER

    # chown -R $USER:$USER /opt/vagrant # not working
    # vagrant plugin install vagrant-vbguest vagrant-share
    
        # desnt work: wget https://releases.hashicorp.com/vagrant/2.4.3/vagrant_2.4.3_linux_amd64.zip \
            # -O /tmp/vagrant.zip
        # unzip /unzip/vagrant.zip
        # pacman -S --needed fuse2 readline
    # rbenv install 3.3.7
    # yay -S vagrant-bin
    # modprobe vboxdrv
    # modprobe vboxnetflt
    # modprobe -r kvm_intel # disable kvm
    # modprobe -r kvm
}
