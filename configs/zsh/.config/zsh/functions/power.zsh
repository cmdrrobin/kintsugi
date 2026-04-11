function power() {
  upower -i /org/freedesktop/UPower/devices/battery_BAT1 |grep 'time to empty'|awk '{print $4, $5}'
}
