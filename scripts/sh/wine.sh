#!/bin/bash

sudo dpkg --add-architecture i386 && sudo apt update
sudo apt install \
      wine \
      wine32 \
      wine64 \
      libwine \
      libwine:i386 \
      fonts-wine \
      q4wine\
      winetricks\
      playonlinux
