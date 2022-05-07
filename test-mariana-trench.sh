#!/usr/bin/env bash

axel -n 10 -o rom.zip http://download.h2os.com/OnePlus9Pro/MP/LE2120_11_A_OTA_0090_all_bef835_10010111.zip

./tools/rom.sh rom.zip out

rm -r out/rom

ROM=out/rom-deodexed
for apk in `find $ROM -name *.apk`;do
	echo "---- start test $apk ----"
	apkfolder="$(dirname $apk)"
	filenum=`find $apkfolder -name *.apk -o -name *.jar | wc -l`
	folder=${apkfolder#$ROM*}
	apknametmp="$(basename $apk)"
	apkname=${apknametmp%.*}
	if [ "${apkfolder##*/}" != "$apkname" ] || [ $filenum -gt 1 ];then
		outfolder=$folder/$apkname
	else
		outfolder=$folder
	fi
	mkdir -p test/$outfolder
	if unzip -v $apk | grep " classes.dex" >/dev/null; then
		echo "---- $apk has dex file ----"
		mariana-trench --system-jar-configuration-path=$ANDROID_HOME/platforms/android-30/android.jar --apk-path=$apk --output-directory test/$outfolder
	        echo $apk >> result.list
	fi
	echo "---- test $apk done ----"
	echo " "
done

