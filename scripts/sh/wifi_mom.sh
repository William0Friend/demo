#!/bin/bash/env

sudo wpa_supplicant -B -i wlp1s0 -c /home/break/wpa_supplicant_mom.conf && sudo dhclient -nw wlp1s0
