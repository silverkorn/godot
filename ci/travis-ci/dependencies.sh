#!/usr/bin/env bash

#***********************************************************************#
#  dependencies.sh                                                      #
#***********************************************************************#
#                       This file is part of:                           #
#                           GODOT ENGINE                                #
#                    http://www.godotengine.org                         #
#***********************************************************************#
# Copyright (c) 2007-2015 Juan Linietsky, Ariel Manzur.                 #
#                                                                       #
# Permission is hereby granted, free of charge, to any person obtaining #
# a copy of this software and associated documentation files (the       #
# "Software"), to deal in the Software without restriction, including   #
# without limitation the rights to use, copy, modify, merge, publish,   #
# distribute, sublicense, and/or sell copies of the Software, and to    #
# permit persons to whom the Software is furnished to do so, subject to #
# the following conditions:                                             #
#                                                                       #
# The above copyright notice and this permission notice shall be        #
# included in all copies or substantial portions of the Software.       #
#                                                                       #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,       #
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF    #
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.#
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY  #
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,  #
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE     #
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                #
#***********************************************************************#

# Get information from argument (Because of `sudo` restriction)
PLATFORM=$1
BITS=$2

################
# Dependencies #
################

export CACHED_DIR=/usr/local/cached

# Use GCC 4.8+ for better C++11 support
if ! [ "$PLATFORM" == "osx" ] && ! [ "$PLATFORM" == "iphone" ]; then 
	add-apt-repository -y ppa:ubuntu-toolchain-r/test
	apt-get -qq update
	if [ "$CXX" = "g++" ]; then
		if [ "$PLATFORM" == "javascript" ]; then
			apt-get install -y g++-4.7;
			export CXX="g++-4.7" CC="gcc-4.7"
		else
			apt-get install -qq g++-4.8;
			export CXX="g++-4.8" CC="gcc-4.8"
		fi
	fi
	if [ "$BITS" == "32" ]; then
		export CFLAGS=-m32
		export CXXFLAGS=-m32
	fi
fi

# Android
if [ "$PLATFORM" == "android" ]; then
	if [ ! -d "$CACHED_DIR/android-ndk" ]; then
		wget http://dl.google.com/android/ndk/android-ndk-r10e-linux-x86_64.bin
		chmod 775 android-ndk-r10e-linux-x86_64.bin
		./android-ndk-r10e-linux-x86_64.bin -y > /dev/null
		mv android-ndk-r10e android-ndk && mv android-ndk $CACHED_DIR
		chmod -R 775 $CACHED_DIR/android-ndk
	fi
fi

# Blackberry 10
# *** TO FIX: Quit or accept licence agreement automatically
#if [ "$PLATFORM" == "bb10" ] ]; then 
#	# Around 400 MB download (Try to cache the directory: http://docs.travis-ci.com/user/caching/)
#	export BB10_SDK_FILENAME=momentics-2.1.2-201503050937.linux.x86_64.run && wget --quiet -P /tmp/ https://developer.blackberry.com/native/downloads/fetch/$BB10_SDK_FILENAME
#	bash /tmp/$BB10_SDK_FILENAME --quiet --nox11 <<END
#	y
#	END
#	# TODO: Finish this part
#fi

# Javascript
if [ "$PLATFORM" == "javascript" ]; then
	# Install CMake (Emscripten dependency)
	if [ ! -d "$CACHED_DIR/cmake" ]; then
		apt-get -qq remove cmake
		wget http://www.cmake.org/files/v3.2/cmake-3.2.2-Linux-x86_64.tar.gz
		tar xfz cmake-3.2.2-Linux-x86_64.tar.gz && rm cmake-3.2.2-Linux-x86_64.tar.gz
		mv cmake-3.2.2-Linux-x86_64 cmake && mv cmake $CACHED_DIR
		chmod -R 775 $CACHED_DIR/cmake
	fi
	export PATH=$PATH:/usr/local/cached/cmake/bin
	
	# Install Emscripten
	if [ ! -d "$CACHED_DIR/emsdk_portable" ]; then
		wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz 
		tar xfz emsdk-portable.tar.gz && rm emsdk-portable.tar.gz
		mv emsdk_portable $CACHED_DIR && pushd $CACHED_DIR/emsdk_portable
		chmod -R 775 $CACHED_DIR/emsdk_portable
		./emsdk update >/dev/null
		sed -i.bak 's/-xvf/-xf/g' emsdk
		./emsdk install latest >/dev/null
		./emsdk activate latest >/dev/null
		source ./emsdk_env.sh
		popd
	fi
	export PATH=$PATH:$CACHED_DIR/emsdk_portable
fi

# Linux (incl. Server)
if [ "$PLATFORM" == "x11" ] || [ "$PLATFORM" == "server" ]; then
	apt-get -qq install scons pkg-config libx11-dev libxcursor-dev build-essential libasound2-dev libfreetype6-dev libgl1-mesa-dev libglu-dev libssl-dev libxinerama-dev
fi

# MacOSX & iOS
#if [ "$PLATFORM" == "osx" ] || [ "$PLATFORM" == "iphone" ]; then
#	#ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
#	brew install scons
#fi

# Windows
if [ "$PLATFORM" == "windows" ]; then
	if [ "$BITS" == "32" ]; then
		apt-get -qq install gcc-mingw-w64-i686 g++-mingw-w64-i686 binutils-mingw-w64-i686
	elif [ "$BITS" == "64" ]; then
		apt-get -qq install gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 binutils-mingw-w64-x86-64
	fi
fi
