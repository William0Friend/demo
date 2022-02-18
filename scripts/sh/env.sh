#!/bin/bash

# One line for .bashrc
echo "export VAR="value"" >> ~/.bashrc && source ~/.bashrc


# One line for bash_profile
echo "export VAR="value"" >> ~/.bash_profile && source ~/.bash_profile


# One line for /etc/environment
echo "export VAR="value"" >> /etc/environment && source /etc/environment

#PATH
echo "export PATH="<path>:$PATH"" >> ~/.bashrc && source ~/.bashrc:

