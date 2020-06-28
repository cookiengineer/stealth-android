#!/bin/bash

export ANDROID_HOME="/opt/android-sdk";
export ANDROID_SDK_VERSION="30";
export ANDROID_NDK="/opt/android-ndk";
export ANDROID_NDK_HOME="/opt/android-ndk";

HOST_OS="linux";
HOST_ARCH="x86_64";
HOST_ROOT="$PWD";



build_node() {

	arch="$1";

	if [[ "$arch" == "armeabi-v7a" ]]; then
		DEST_CPU="arm";
		TOOLCHAIN_NAME="armv7a-linux-androideabi";
	elif [[ "$arch" == "arm64-v8a" ]]; then
		DEST_CPU="arm64";
		TOOLCHAIN_NAME="aarch64-linux-android";
		ARCH="arm64";
	elif [[ "$arch" == "x86" ]]; then
		DEST_CPU="ia32";
		TOOLCHAIN_NAME="i686-linux-android";
	elif [[ "$arch" == "x86_64" ]]; then
		DEST_CPU="x64";
		TOOLCHAIN_NAME="x86_64-linux-android";
		ARCH="x64";
	fi;

	if [[ "$DEST_CPU" != "" ]]; then

		export CC_host=$(which gcc);
		export CXX_host=$(which g++);

		export GYP_DEFINES="target_arch=$ARCH v8_target_arch=$ARCH android_target_arch=$ARCH host_os=$HOST_OS OS=android";

		TOOLCHAIN_PATH="$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST_OS-$HOST_ARCH";
		export PATH="$TOOLCHAIN_PATH/bin:$PATH";
		export CC="$TOOLCHAIN_PATH/bin/$TOOLCHAIN_NAME$ANDROID_SDK_VERSION-clang";
		export CXX="$TOOLCHAIN_PATH/bin/$TOOLCHAIN_NAME$ANDROID_SDK_VERSION-clang++";

		cd "$HOST_ROOT/node";

		chmod +x ./configure;

		./configure --dest-cpu="$DEST_CPU" --dest-os="android" --without-intl --openssl-no-asm --cross-compiling --shared;

		if [[ "$?" == "0" ]]; then
			cd "$HOST_ROOT/node";
			make;
		fi;

	fi;

}

build_node "armeabi-v7a";
# build_node "arm64-v8a";
# build_node "x86";
# build_node "x86_64";

