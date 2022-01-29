#!/usr/bin/env bash

axel -n 10 -o rom.zip http://download.h2os.com/OnePlus9Pro/MP/LE2120_11_A_OTA_0090_all_bef835_10010111.zip

./tools/rom.sh rom.zip out

rm -r out/rom

ROM=out/rom-deodexed
for apk in `find $ROM -name *.apk`;do
	echo "---- start test $apk ----"
	if unzip -v $apk | grep " classes.dex" >/dev/null; then
		echo "---- $apk has dex file ----"
		mariana-trench --system-jar-configuration-path=$ANDROID_HOME/platforms/android-30/android.jar --apk-path=$apk
	        echo $apk >> result.list
	fi
	echo "---- test $apk done ----"
	echo " "
done

