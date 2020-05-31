#!/usr/bin/env bash

axel -n 20 -o rom.ozip http://fs.oppo.com/3/oppowww/androidrom/pafm00/PAFM00_11_OTA_3090_all_zl3f9pDDviaO.ozip

curl -o ozipdecrypt.py https://raw.githubusercontent.com/bkerler/oppo_ozip_decrypt/master/ozipdecrypt.py

python ozipdecrypt.py rom.ozip

rm rom.ozip

./rom.sh rom.zip out

rm -r out/rom

for apk in `find out/rom-deodexed -name *.apk`;do
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
	mkdir -p flowdroidtest/$outfolder
	if unzip -v $apk | grep " classes.dex" >/dev/null; then
		echo "---- $apk has dex file ----"
		java -jar FlowDroid/soot-infoflow-cmd/target/soot-infoflow-cmd-jar-with-dependencies.jar -a $apk -p ${ANDROID_HOME}/platforms -s FlowDroid/soot-infoflow-android/SourcesAndSinks.txt -o flowdroidtest/$outfolder/testresult.xml -d
	fi
	echo "---- test $apk done ----"
	echo " "
done

