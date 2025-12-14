#!/bin/sh

# cmake -S . -B ./build_ios_device \
#     -G Xcode \
#     -DCMAKE_SYSTEM_NAME=iOS \
#     -DCMAKE_OSX_ARCHITECTURES=arm64 \
#     -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0 \
#     -DMyHTML_BUILD_STATIC=ON \
#     -DMyHTML_BUILD_SHARED=OFF

# cmake --build ./build_ios_device --config Release

cmake -S . -B ./build_ios_sim \
    -G Xcode \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_SYSROOT=iphonesimulator \
    -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=11.0 \
    -DCMAKE_C_COMPILER=$(xcrun -sdk iphonesimulator -find clang) \
    -DCMAKE_CXX_COMPILER=$(xcrun -sdk iphonesimulator -find clang++) \
    -DMyHTML_BUILD_STATIC=ON \
    -DMyHTML_BUILD_SHARED=OFF

cmake --build ./build_ios_sim --config Release

rm -rf ./build_ios/myhtml_ios.xcframework

xcodebuild -create-xcframework \
    -library ./build_ios_device/Release-iphoneos/libmyhtml_static.a \
    -library ./build_ios_sim/Release-iphonesimulator/libmyhtml_static.a \
    -output ./build_ios/myhtml_ios.xcframework