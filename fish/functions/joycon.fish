function joycon
    set mac 90:45:28:80:98:FE
    bluetoothctl remove $mac >/dev/null 2>&1
    echo "Hold the sync button on the Joy-Con now..."
    bluetoothctl --timeout 15 scan on >/dev/null
    bluetoothctl pair $mac
    and bluetoothctl trust $mac
    and bluetoothctl connect $mac
    and echo "Connected. Press SL + SR."
end
