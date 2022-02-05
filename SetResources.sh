#!sh

rc Haiku/Rsrc/Blackbox.rdef -o Haiku/Rsrc/Blackbox.rsrc
xres -o Blackbox Haiku/Rsrc/Blackbox.rsrc
mimeset -F Blackbox
