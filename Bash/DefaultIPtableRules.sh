#!/bin/bash
# Setup default statefull IPv4 and IPv6 firewall rules, allow SSH from LAN.
# Add persistant rules after reboot.

# IPv4 Rules
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW --dport 22 -j ACCEPT
iptables -A INPUT -p icmp -m icmp --icmp-type 8 --source 10.0.0.0/24 -j ACCEPT

iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# IPv6 Rules
ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
ip6tables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# Save Rules
if [ ! -e /etc/iptables ]; then 
	echo "---Creating directory /etc/iptables---"
	mkdir /etc/iptables
fi
echo "---IPv4 rules saved to /etc/iptables/rules.v4---"
iptables-save | tee /etc/iptables/rules.v4
echo "---IPv6 rules saved to /etc/iptables/rules.v6---"
ip6tables-save | tee /etc/iptables/rules.v6

if [ ! -f /etc/network/if-pre-up.d/iptables ]; then 
	echo "---Creating file /etc/network/if-pre-up.d/iptables---"
	touch  /etc/network/if-pre-up.d/iptables
fi
echo '#!/bin/sh' > /etc/network/if-pre-up.d/iptables
echo '/sbin/iptables-restore /etc/iptables.rules.v4' >> /etc/network/if-pre-up.d/iptables
echo '/sbin/ip6tables-restore /etc/iptables.rules.v6' >> /etc/network/if-pre-up.d/iptables
chmod +x /etc/network/if-pre-up.d/iptables
