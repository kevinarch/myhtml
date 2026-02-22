#!/bin/sh
set -e

# Directories
BUILD_DIR="build_ios"
DEVICES_BUILD_DIR="${BUILD_DIR}/device"
SIM_BUILD_DIR="${BUILD_DIR}/sim"
INSTALL_DIR="${BUILD_DIR}/install"
OUTPUT_XCFRAMEWORK="${BUILD_DIR}/myhtml_ios.xcframework"

# Clean
rm -rf "${BUILD_DIR}"

echo "=== Building for iOS Device (arm64) ==="
cmake -S . -B "${DEVICES_BUILD_DIR}" \
    -G Xcode \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0 \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/device" \
    -DMyHTML_BUILD_STATIC=ON 

cmake --build "${DEVICES_BUILD_DIR}" --config Release
cmake --install "${DEVICES_BUILD_DIR}" --config Release

echo "=== Building for iOS Simulator (x86_64;arm64) ==="
cmake -S . -B "${SIM_BUILD_DIR}" \
    -G Xcode \
    -DCMAKE_SYSTEM_NAME=iOS \
    -DCMAKE_OSX_SYSROOT=iphonesimulator \
    -DCMAKE_OSX_ARCHITECTURES="x86_64;arm64" \
    -DCMAKE_OSX_DEPLOYMENT_TARGET=12.0 \
    -DCMAKE_C_COMPILER=$(xcrun -sdk iphonesimulator -find clang) \
    -DCMAKE_CXX_COMPILER=$(xcrun -sdk iphonesimulator -find clang++) \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}/sim" \
    -DMyHTML_BUILD_STATIC=ON 

cmake --build "${SIM_BUILD_DIR}" --config Release
cmake --install "${SIM_BUILD_DIR}" --config Release

echo "=== Creating XCFramework ==="
xcodebuild -create-xcframework \
    -library "${INSTALL_DIR}/device/lib/libmyhtml_static.a" \
    -headers "${INSTALL_DIR}/device/include" \
    -library "${INSTALL_DIR}/sim/lib/libmyhtml_static.a" \
    -headers "${INSTALL_DIR}/sim/include" \
    -output "${OUTPUT_XCFRAMEWORK}"

echo "Success! XCFramework located at: ${OUTPUT_XCFRAMEWORK}"