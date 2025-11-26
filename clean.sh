#!/bin/bash
# clean.sh - Clean build directories
# Usage: ./clean.sh [qemux86-64 | qemuarm | qemuarm64 | all]

ARCH=${1:-qemux86-64}

if [ "$ARCH" = "all" ]; then
    echo ">>> Removing entire build directory..."
    rm -rf build/
    echo ">>> Build directory removed."
else
    BUILD_DIR="build/$ARCH"
    if [ -d "$BUILD_DIR" ]; then
        echo ">>> Removing build directory for $ARCH..."
        rm -rf "$BUILD_DIR"
        echo ">>> Build directory for $ARCH removed."
    else
        echo "Error: Build directory '$BUILD_DIR' not found."
    fi
fi