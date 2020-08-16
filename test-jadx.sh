#!/usr/bin/env bash

axel -n 10 -o rom.zip http://bigota.d.miui.com/V11.0.18.0.QJACNXM/miui_CMI_V11.0.18.0.QJACNXM_ba9c7cce1b_10.0.zip

./tools/rom.sh rom.zip out

rm -r out/rom

./tools/tools/jadx.sh out/rom-deodexed out/rom-decompiled-jadx

