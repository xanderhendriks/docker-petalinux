#!/usr/bin/env expect
set timeout -1

# Installing in /opt/petalinux
spawn ./petalinux-final-installer.run /opt/petalinux
expect "Press Enter to display the license agreements"
send "\r"
send "q"
expect "*>*"
send "y\r"
send "q"
expect "*>*"
send "y\r"
send "q"
expect "*>*"
send "y\r"
expect "*Petalinux SDK has been installed to*"
send_user "auto install petalinux done\r"
send_user "wait several minutes to clean up\r"
exit
