# pihole_automator

NB: you should ssh into the wifi ip address or the script will kick you off when it changes the static eth0 interface

You may not have wget installed, this script will install it for you if you do not
```
brew install wget
```

```
wget -O - https://raw.githubusercontent.com/jadamstewart/pihole_automator/main/install_pihole_auto.sh | sudo bash
```

```
wget -O install_pihole_auto.sh https://raw.githubusercontent.com/jadamstewart/pihole_automator/main/install_pihole_auto.sh
chmod +x install_pihole_auto.sh
sudo ./install_pihole_auto.sh
```