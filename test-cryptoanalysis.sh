#!/usr/bin/env bash

#axel -n 20 -o rom.ozip http://fs.oppo.com/3/oppowww/androidrom/pafm00/PAFM00_11_OTA_3090_all_zl3f9pDDviaO.ozip

#curl -o ozipdecrypt.py https://raw.githubusercontent.com/bkerler/oppo_ozip_decrypt/master/ozipdecrypt.py

#python ozipdecrypt.py rom.ozip

#rm rom.ozip
axel -n 20 -o rom.zip http://sysupwrdl.vivo.com.cn/upgrade/official/officialFiles/PD1924_A_1.14.5-update-full_1589189491.zip

./tools/rom.sh rom.zip out

rm -r out/rom

ROM=out/rom-deodexed
free -h
for apk in `find $ROM/system/app -name *.apk`;do
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
	mkdir -p cryptoanalysistest/$outfolder
	if unzip -v $apk | grep " classes.dex" >/dev/null; then
		echo "---- $apk has dex file ----"
                java -jar -Xmx8g -Xss60m CryptoAnalysis/CryptoAnalysis-Android/build/CryptoAnalysis-Android-2.7.3-SNAPSHOT-jar-with-dependencies.jar $apk ${ANDROID_HOME}/platforms Crypto-API-Rules/JavaCryptographicArchitecture/src cryptoanalysistest/$outfolder
	fi
	echo "---- test $apk done ----"
	echo " "
done

