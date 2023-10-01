# Setup Netowk

scan for network card
```sh
iwconfig
```

my one is named `wlan0`

scan for network using wlan network
```sh
iwlist wlan0 scan | grep ESSID
```

supple password
```sh
wpa_passphrase "SSID Name" password | tee /etc/wpa_supplicant.conf
```

connect
```sh
wpa_supplicant -B -c /etc/wpa_supplicant.conf -i wlan0
```


verify
```sh
iwconfig
```

obtain client
```sh
dhclient wlan0
```