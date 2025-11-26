#!/bin/bash
# qemu.sh - Run QEMU for a specific architecture
# Usage: ./qemu.sh [qemux86-64 | qemuarm | qemuarm64]

ARCH=${1:-qemux86-64}
BUILD_DIR="build/$ARCH"

if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build directory '$BUILD_DIR' not found."
    echo "Run: ./build.sh $ARCH"
    exit 1
fi

echo ">>> Starting QEMU for $ARCH..."
source poky/oe-init-build-env $BUILD_DIR > /dev/null
runqemu $ARCH nographic slirp