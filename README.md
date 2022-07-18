# pihole_automator

This is mostly just a quick tool for me to set up a pihole quickly. Its not necessarily meant for a larger audience. There are almost certainly better ways to do this. I wanted to play with some bash scripting and configuration. Some of the settings are hardcoded that most people probably wouldn't want. 

The pi should be imaged with the base pi image. Wifi settings and hostname should be done as part of the image. 

NB: you should ssh into the wifi ip address or the script will kick you off when it changes the static eth0 interface

You may not have wget installed, this script will install it for you if you do not (Once I figure out how to change in and out of sudo)


This should do it all in one go:
```
wget -O - https://raw.githubusercontent.com/jadamstewart/pihole_automator/main/install_pihole_auto.sh | sudo bash
```

This version just downloads the script, makes it executable, and then runs it so you can have a little more control:
```
wget -O install_pihole_auto.sh https://raw.githubusercontent.com/jadamstewart/pihole_automator/main/install_pihole_auto.sh
chmod +x install_pihole_auto.sh
sudo ./install_pihole_auto.sh
```