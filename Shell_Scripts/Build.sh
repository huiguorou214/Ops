#!/bin/bash
#Revision:svn版本号 BuildMode：0-打补丁 1-完整打包 2-预编译AssetBundle PatchesMode：0-缺省 1-补丁包要更新dll Platform：Android iOS OSSType:0-阿里云 1-腾讯云
UNITY_PATH=/Applications/Unity/Unity.app/Contents/MacOS/Unity
PROJECT_PATH=$(dirname $(pwd))
VERSION_FILE=$PROJECT_PATH/Assets/version.xml
OSS=`grep 'cdnTest="http://tscdn.acgrun.com/' $VERSION_FILE | awk -F 'cdnTest="http://tscdn.acgrun.com/' '{print $2}' | awk -F '/"' '{print $1}'`
OSS_PKG=`grep 'cdn1="http://tscdn.acgrun.com/' $VERSION_FILE | awk -F 'cdn1="http://tscdn.acgrun.com/' '{print $2}' | awk -F '/"' '{print $1}'`
CDN_PKG=`grep 'cdn1="http://tscdn.acgrun.com/' $VERSION_FILE | awk -F 'cdn1="' '{print $2}' | awk -F '/"' '{print $1}'`
APK_PATH=$PROJECT_PATH/Build/Android/wyyl/build/outputs/apk/wyyl-release.apk
PATCHES_PATH=$PROJECT_PATH/Build/Patches
ARCHIVE_PATH=iOS/wyyl/build/Unity-iPhone.xcarchive
IPA_PATH=$PROJECT_PATH/Build/iOS/wyyl/build

echo "当前工程：" $PROJECT_PATH

if [ "$Platform" == "Android" ]; then
	echo "当前平台：Android" 
else
	echo "当前平台：iOS" 
fi

if [ $BuildMode == 1 ]; then
	echo "打包模式：1-完整打包" 
elif [ $BuildMode == 0 ]; then
	echo "打包模式：0-打补丁包"
else
	echo "打包模式：2-预编译AssetBundle"
fi

if [ $PatchesMode == 0 ]; then
	echo "补丁模式：0-一般"
else
	echo "补丁模式：1-更新dll"
fi

if [ $OSSType == 0 ]; then
	echo "对象存储：阿里云" 
elif [ $OSSType == 1 ]; then
	echo "对象存储：腾讯云"
fi

echo "开始更新svn，版本：" $Revision
svn update ./../Assets/ -r $Revision
if [ $? != 0 ]; then
	echo "svn 更新失败"
	exit 1
fi

svn stat ./../Assets/ | grep 'conflicts'
if [ $? -ne 1 ]; then
	echo "svn 更新失败，需解决冲突"
	exit 1
fi

if [ $BuildMode == 1 ]; then
	echo "Unity 命令行编译并生成'$Platform'工程"
	$UNITY_PATH -batchmode -projectPath $PROJECT_PATH -executeMethod CustomBuildPipeline.PipelineFull -quit -logFile ./BuildLog.txt
elif [ $BuildMode == 0 ]; then
	echo "Unity 命令行编译并生成补丁文件"
	$UNITY_PATH -batchmode -projectPath $PROJECT_PATH -quit -logFile ./BuildLog.txt -executeMethod CustomBuildPipeline.PipelinePatches $PatchesMode
else
	echo "Unity 命令行编译AssetBundle"
	$UNITY_PATH -batchmode -projectPath $PROJECT_PATH -quit -logFile ./BuildLog.txt -executeMethod Packager.BuildAssetBundle
fi

if [ $? != 0 ]; then
	cat ./BuildLog.txt
	echo "Unity编译管线失败"
	exit 1
elif [ $BuildMode == 2 ]; then
	echo "预编译AssetBundle成功，SVN版本：" $Revision
	exit 0
fi

if [ $BuildMode == 1 ]; then
	if [ "$Platform" == "Android" ]; then
		echo "执行Gradle命令行编译"
		cd Android/wyyl
		gradle assembleRelease
		if [ $? != 0 ]; then
			echo "Gradle编译失败"
			exit 1
		fi
		echo "开始上传APK至阿里云"
		
		if [ $OSSType == 0 ]; then
			~/ossutilmac64 cp -f $APK_PATH oss://tkbns/$OSS_PKG/
		elif [ $OSSType == 1 ]; then
			coscmd upload $APK_PATH $OSS_PKG/
		fi
		
		if [ $? != 0 ]; then
			echo "上传失败"
			exit 1
		fi
		
		echo "需要手动刷新cdn：" $CDN_PKG/wyyl-release.apk "，然后上传版本号文件：" $VERSION_FILE "至对象存储：" $OSS
	else
		echo "执行Xcode命令行编译"
		xcodebuild archive -project iOS/wyyl/Unity-iPhone.xcodeproj -scheme Unity-iPhone -configuration Release -archivePath $ARCHIVE_PATH #DEVELOPMENT_TEAM="8VB74T2QQN"
		if [ $? != 0 ]; then
			echo "Xcode归档失败"
			exit 1
		fi
		xcodebuild -exportArchive -archivePath $ARCHIVE_PATH -exportPath $IPA_PATH -exportOptionsPlist iOS/ExportOptions.plist
		if [ $? != 0 ]; then
			echo "生成IPA失败"
			exit 1
		fi
		
		echo "开始上传IPA至对象存储"
		if [ $OSSType == 0 ]; then
			~/ossutilmac64 cp -f $IPA_PATH/Unity-iPhone.ipa oss://tkbns/$OSS_PKG/
		elif [ $OSSType == 1 ]; then
			coscmd upload $IPA_PATH/Unity-iPhone.ipa $OSS_PKG/
		fi
		
		if [ $? != 0 ]; then
			echo "上传失败"
			exit 1
		fi

		echo "需要手动刷新cdn：" $CDN_PKG/Unity-iPhone.ipa "，然后上传版本号文件：" $VERSION_FILE "至对象存储：" $OSS
	fi
else
	echo "开始上传补丁文件至对象存储"
	if [ $OSSType == 0 ]; then
		~/ossutilmac64 cp -f -r $PATCHES_PATH/assets oss://tkbns/$OSS/assets/ --exclude ".DS_Store"
	elif [ $OSSType == 1 ]; then
		coscmd upload -r $PATCHES_PATH/assets $OSS/
	fi
	if [ $? != 0 ]; then
		echo $PATCHES_PATH/assets "上传失败"
		exit 1
	fi
	
	if [ $OSSType == 0 ]; then
		~/ossutilmac64 cp -f $PATCHES_PATH/game.manifest oss://tkbns/$OSS/
	elif [ $OSSType == 1 ]; then
		coscmd upload $PATCHES_PATH/game.manifest $OSS/
	fi
	if [ $? != 0 ]; then
		echo $PATCHES_PATH/game.manifest "上传失败"
		exit 1
	fi
	
	if [ $OSSType == 0 ]; then
		~/ossutilmac64 cp -f $PATCHES_PATH/StreamingAssets oss://tkbns/$OSS/
	elif [ $OSSType == 1 ]; then
		coscmd upload $PATCHES_PATH/StreamingAssets $OSS/
	fi
	if [ $? != 0 ]; then
		echo $PATCHES_PATH/StreamingAssets "上传失败"
		exit 1
	fi
	
	if [ $PatchesMode == 1 ]; then
		if [ $OSSType == 0 ]; then
			~/ossutilmac64 cp -f $PATCHES_PATH/Assembly-CSharp.dll oss://tkbns/$OSS/
		elif [ $OSSType == 1 ]; then
			coscmd upload $PATCHES_PATH/Assembly-CSharp.dll $OSS/
		fi
		if [ $? != 0 ]; then
			echo $PATCHES_PATH/Assembly-CSharp.dll "上传失败"
			exit 1
		fi
	fi
	
	if [ $OSSType == 0 ]; then
		~/ossutilmac64 cp -f $VERSION_FILE oss://tkbns/$OSS/
	elif [ $OSSType == 1 ]; then
		coscmd upload $VERSION_FILE $OSS/
	fi
	if [ $? != 0 ]; then
		echo $VERSION_FILE "上传失败"
		exit 1
	fi
fi

CLIENT_VERSION=`grep '" version="' $VERSION_FILE | awk -F 'version="' '{print $2}' | awk -F '"' '{print $1}'`
echo "执行成功，客户端版本更新至：" $CLIENT_VERSION "SVN版本：" $Revision
	