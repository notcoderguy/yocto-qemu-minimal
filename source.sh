#!/bin/bash
# source.sh - Source Yocto environment for specific architectures
# Usage: source ./source.sh [qemux86-64 | qemuarm | qemuarm64]
# Note: This script should be sourced (not executed) to set up the environment in your current shell.

ARCH=${1:-qemux86-64}
BUILD_DIR="build/$ARCH"

echo ">>> Sourcing environment for architecture: $ARCH"

# Check if build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build directory '$BUILD_DIR' not found."
    echo "Please run ./build.sh $ARCH first to set up the build environment."
    exit 1
fi

# Source the environment into the build directory
source poky/oe-init-build-env $BUILD_DIR

echo ">>> Environment sourced. You can now run bitbake commands manually."