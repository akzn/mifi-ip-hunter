> Dumb Noobie:
aye test pake ini 
adb shell svc data disable
adb shell svc data enable

works (test lwat laptop ke hp)

bwt dr openwrt pastikan sudah install modul adb

> Dumb Noobie:
file openclash-check-ping.sh baris 69, rubah ke 
adb shell svc data disable
sleep 5
adb shell svc data enable

> Dumb Noobie:
FYI ini script bwat cek ping dr proxy openclash

klo mau dibikin cek langsung lwt direk ping instead of openclash

ganti line 26 jadi DELAY_CHECK_URL="http://www.gstatic.com/generate_204"

line 38 jadi delay_check_response=$(curl -s "${DELAY_CHECK_URL}")
