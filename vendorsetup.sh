for device in $(cat vendor/cardinal/cardinal.devices)
do
add_lunch_combo cardinal_$device-userdebug
done