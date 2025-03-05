#!/bin/sh

function configure_shell() {
    echo "( Configuring shell )"
    sudo pacman -S --needed bash-language-server zsh zsh-autocomplete || exit 1
}

function install_emacs() {
    echo "( Installing emacs )"
    [ ! -d ~/dev/ ] && mkdir ~/dev/

	[ ! -d ~/dev/emacs-conf/ ] && \
        git clone https://github.com/sjlwa/emacs-conf.git ~/dev/emacs-conf

    [  -f /usr/local/bin/emacs ] && { echo "Emacs is already installed -- skipping"; return 0; }

    . ~/dev/emacs-conf/download.sh && \
        emacs_download && emacs_extract && emacs_install || \
            { echo "[ Failed to install emacs ]"; exit 1;}
}

function install_ruby() {
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash
    # check before ^
    pacman -S --needed rbenv ruby-build || { exit 1; }
    rbenv install 3.4.1 && \
        gem install bundler
}

function install_dotnet() {
    echo "( Installing dotnet )"
    [ ! -f ~/.local/share/dotnet-install.sh ] && \
        wget https://dot.net/v1/dotnet-install.sh -O ~/.local/share/dotnet-install.sh || \
            { echo "Failed to download dotnet-install.sh"; exit 1; }
    chmod +x ~/.local/share/dotnet-install.sh
    
    ~/.local/share/dotnet-install.sh --channel 9.0 || \
        { echo "Failed to install Dotnet Sdk"; exit 1; }
}

function install_devtools() {
    # install_ruby || exit 1
    install_dotnet || exit 1
}
