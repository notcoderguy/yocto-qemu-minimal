#!/bin/bash
# sdk.sh - Generate SDK for specific architectures
# Usage: ./sdk.sh [qemux86-64 | qemuarm | qemuarm64]

ARCH=${1:-qemux86-64}
BUILD_DIR="build/$ARCH"

echo ">>> Generating SDK for architecture: $ARCH"

# 0. Check if build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build directory '$BUILD_DIR' not found."
    echo "Please run ./build.sh $ARCH first."
    exit 1
fi

# 1. Source the environment into a specific build directory
source poky/oe-init-build-env $BUILD_DIR

# 2. Generate SDK
echo ">>> Starting SDK generation for $ARCH..."
bitbake -c populate_sdk minimal-can-image