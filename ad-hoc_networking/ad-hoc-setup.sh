#!/system/bin/sh
# Reference: http://www.olsr.org/?q=olsr_on_android

SSID="test-manet"
FREQUENCY="2437"
INTERFACE=wlan0
IPv4ADDR="10.0.0.101/24"
IPv6ADDR="2001::101/64"
WPA_CLI="wpa_cli -i $INTERFACE"
PAUSE=2
RESELECT_INTERVAL=10

echo "Scan results:"
$WPA_CLI scan_results
ADHOCNET=`$WPA_CLI add_network`
echo "Added network no. $ADHOCNET" ; sleep $PAUSE
echo "Set ad-hoc mode..."
$WPA_CLI set_network $ADHOCNET mode 1 ; sleep $PAUSE
echo "Set SSID..."
$WPA_CLI set_network $ADHOCNET ssid \"$SSID\" ; sleep $PAUSE
echo "Set frequency..."
$WPA_CLI set_network $ADHOCNET frequency $FREQUENCY ; sleep $PAUSE
echo "Set no key management..."
$WPA_CLI set_network $ADHOCNET key_mgmt NONE ; sleep $PAUSE
echo "Enable network..."
$WPA_CLI enable_network $ADHOCNET ; sleep $PAUSE
echo "Enable scan of hidden networks..."
$WPA_CLI ap_scan 2 ; sleep $PAUSE
echo "Select new ad hoc network..."
$WPA_CLI select_network $ADHOCNET ; sleep $PAUSE

# Reference: http://www.tldp.org/HOWTO/Linux+IPv6-HOWTO/x1035.html
echo "Set IPv4 address..."
ip -4 addr add $IPv4ADDR dev $INTERFACE ; ip -4 addr show dev $INTERFACE
echo "Set IPv6 address..."
ip -6 addr add $IPv6ADDR dev $INTERFACE ; ip -6 addr show dev $INTERFACE

# Reference: https://groups.google.com/forum/?fromgroups=#!topic/android-x86/7AruOgJ3ddc
echo "Set DNS server(s)..."
setprop net.dns1 8.8.8.8
#setprop net.dns2 192.168.1.1

# The following workaround may be needed on some devices
echo
echo "Workaround: endless loop for re-selecting the network each $RESELECT_INTERVAL seconds..."
while [ 1 -lt 2 ]
do
  echo -n "."
  $WPA_CLI select_network $ADHOCNET > /dev/null ; sleep $RESELECT_INTERVAL
done

