#!/bin/bash



# XXX: API Levels
# Android 10   -> 29
# Android  9   -> 28
# Android  8.1 -> 27
# Android  8.0 -> 26



export ANDROID_HOME="/opt/android-sdk";
export ANDROID_SDK_VERSION="28";
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
		PLATFORM_NAME="arm-linux-androideabi";
		ARCH="arm";
		# TODO: Verify that ARCH is arm for v8
	elif [[ "$arch" == "arm64-v8a" ]]; then
		DEST_CPU="arm64";
		TOOLCHAIN_NAME="aarch64-linux-android";
		PLATFORM_NAME="aarch64-linux-androideabi";
		ARCH="arm64";
	elif [[ "$arch" == "x86" ]]; then
		DEST_CPU="ia32";
		TOOLCHAIN_NAME="i686-linux-android";
		PLATFORM_NAME="i686-linux-android";
		ARCH="ia32";
	elif [[ "$arch" == "x86_64" ]]; then
		DEST_CPU="x64";
		TOOLCHAIN_NAME="x86_64-linux-android";
		PLATFORM_NAME="x86_64-linux-android";
		ARCH="x64";
	fi;

	if [[ "$DEST_CPU" != "" ]]; then

		export GYP_DEFINES="target_arch=$ARCH v8_target_arch=$ARCH android_target_arch=$ARCH host_os=$HOST_OS OS=android";

		export CC_host="$(which clang)";
		export CXX_host="$(which clang++)";
		export AR_host="$(which ar)";
		export AS_host="$(which as)";
		export LD_host="$(which ld)";
		export NM_host="$(which nm)";
		export RANLIB_host="$(which ranlib)";
		export STRIP_host="$(which strip)";

		TOOLCHAIN_PATH="$ANDROID_NDK/toolchains/llvm/prebuilt/$HOST_OS-$HOST_ARCH";
		export PATH="$TOOLCHAIN_PATH/bin:$PATH";

		export CC_target="$TOOLCHAIN_PATH/bin/$TOOLCHAIN_NAME$ANDROID_SDK_VERSION-clang";
		export CXX_target="$TOOLCHAIN_PATH/bin/$TOOLCHAIN_NAME$ANDROID_SDK_VERSION-clang++";
		export AR_target="$TOOLCHAIN_PATH/bin/$PLATFORM_NAME-ar";
		export AS_target="$TOOLCHAIN_PATH/bin/$PLATFORM_NAME-as";
		export LD_target="$TOOLCHAIN_PATH/bin/$PLATFORM_NAME-ld";
		export NM_target="$TOOLCHAIN_PATH/bin/$PLATFORM_NAME-nm";
		export RANLIB_target="$TOOLCHAIN_PATH/bin/$PLATFORM_NAME-ranlib";
		export STRIP_target="$TOOLCHAIN_PATH/bin/$PLATFORM_NAME-strip";


		cd "$HOST_ROOT/node";

		chmod +x ./configure;

		./configure \
			--dest-cpu="$DEST_CPU"\
			--dest-os="android" \
			--without-intl \
			--without-inspector \
			--without-node-snapshot \
			--without-node-code-cache \
			--without-npm \
			--without-snapshot \
			--openssl-no-asm \
			--cross-compiling;

		if [[ "$?" == "0" ]]; then

			cd "$HOST_ROOT/node";

			export LDFLAGS=-shared;
			make;


			if [[ -f "$HOST_ROOT/node/out/Release/lib.target/libnode.so" ]]; then

				mkdir -p "$HOST_ROOT/libnode/$arch";
				cp "$HOST_ROOT/node/out/Release/lib.target/libnode.so" "$HOST_ROOT/libnode/$arch/libnode.so";

			fi;

		fi;

		if [[ "$?" == "0" ]]; then

			cd "$HOST_ROOT/node";

			export LDFLAGS=-shared;
			make;


			if [[ -f "$HOST_ROOT/node/out/Release/node" ]]; then

				mkdir -p "$HOST_ROOT/libnode/$arch";
				cp "$HOST_ROOT/node/out/Release/node" "$HOST_ROOT/libnode/$arch/node";

			fi;

		fi;

	fi;

}

# build_node "armeabi-v7a";
build_node "arm64-v8a";
# build_node "x86";
# build_node "x86_64";

