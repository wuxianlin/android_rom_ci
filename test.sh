#!/usr/bin/env bash

axel -n 10 -o rom.zip http://bigota.d.miui.com/V11.0.2.0.OADCNXM/miui_MINote2_V11.0.2.0.OADCNXM_7224e431a4_8.0.zip

./rom.sh rom.zip out

./tools/apktool.sh out/rom-deodexed out/rom-decompiled-apktool

