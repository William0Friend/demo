#!/bin/bash/env

sudo wpa_supplicant -B -i wlan0 -c /home/break/wpa_supplicant.conf && sudo dhclient -nw wlan0
