trap CLEAN_UP SIGINT SIGTERM

function CLEAN_UP(){
    echo Killing processes...
    killall dnsmasq
    killall hostapd

    echo Reverting iptables rules...
    sysctl -w net.ipv4.ip_forward=0
}

ifconfig wlan0 10.0.0.1/24 up
dnsmasq -C /etc/dnsmasq.conf
sysctl -w net.ipv4.ip_forward=1
iptables -P FORWARD ACCEPT
iptables --table nat -A POSTROUTING -o eth0 -j MASQUERADE
hostapd /etc/hostapd.conf -B

while :
do
    sleep 30
done