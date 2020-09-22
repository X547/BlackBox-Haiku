#!sh

chmod +x Blackbox.so
rc Haiku/Rsrc/Blackbox.rdef -o Haiku/Rsrc/Blackbox.rsrc
xres -o Blackbox.so Haiku/Rsrc/Blackbox.rsrc
mimeset -f Blackbox.so
