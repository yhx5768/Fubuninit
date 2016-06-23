#!/bin/bash

if [[ "$1" == "extract" ]]; then
	tar xvf $(find ../bin/theme -type f) -C $FUB_TMP_DIR
	mv $(find $FUB_TMP_DIR/humanity* -maxdepth 0 -type d)/Humanity* /usr/share/icons
fi

if [[ "$1" == "change" ]]; then
	dconf write /org/gnome/desktop/interface/icon-theme "'Humanity'"
fi