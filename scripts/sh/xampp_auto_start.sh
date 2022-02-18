#!/bin/bash
# script to start xampp on automatically at boot
sudo ln -s /opt/lampp/lampp /etc/init.d/lampp \
sudo update-rc.d lampp start 80 2 3 4 5 . stop 30 0 1 6 .

exit
