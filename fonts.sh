#!/bin/sh

function configure_iosevka_font() {
    [ -f ~/.fonts/Iosevka/ ] && { exit 0; }

    echo "( Installing iosevka font )"
	FONT_RELEASE_URL='https://api.github.com/repos/be5invis/Iosevka/releases/latest'
	FONT_FILE_URL=$(curl -s $FONT_RELEASE_URL | \
                        jq -r ".assets[] | .browser_download_url" | \
                        grep PkgTTC-Iosevka-)

	curl -L --fail --show-error -o /tmp/Iosevka.zip $FONT_FILE_URL || \
        { echo "[ Failed to download font ]"; exit 1; }

	unzip /tmp/Iosevka.zip -d ~/.fonts/Iosevka && \
		rm ~/.fonts/Iosevka.zip && \
		fc-cache &&
		xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Iosevka 16"
}

function configure_fonts() {
    [ -d "~/.fonts" ] && mkdir ~/.fonts
    configure_iosevka_font
}
