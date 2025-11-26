#!/bin/bash
# build.sh - Configure and Build for specific architectures
# Usage: ./build.sh [qemux86-64 | qemuarm | qemuarm64]

ARCH=${1:-qemux86-64}
BUILD_DIR="build/$ARCH"
PROJECT_ROOT=$(pwd)
DL_DIR="${PROJECT_ROOT}/downloads"
SSTATE_DIR="${PROJECT_ROOT}/sstate-cache"

echo ">>> Initializing build for architecture: $ARCH"

# 0. Check if build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build directory '$BUILD_DIR' not found."
    echo "Creating build directory..."
    mkdir -p $BUILD_DIR
fi

# 1. Source the environment into a specific build directory
source poky/oe-init-build-env $BUILD_DIR

# 2. Add layers (suppress error if already exists)
bitbake-layers add-layer ../../meta-openembedded/meta-oe || true
bitbake-layers add-layer ../../meta-minimal-can || true

# 3. Configure local.conf dynamically
CONF_FILE="conf/local.conf"

# --- A. Configure MACHINE (Robust Version) ---
# Check if the correct machine is already set. If not, fix it.
# We grep for 'MACHINE = "ARCH"' (hard assignment) OR 'MACHINE ?= "ARCH"'
if ! grep -q "^MACHINE.*\"$ARCH\"" $CONF_FILE; then
    echo "Configuring MACHINE to $ARCH..."
    
    # 1. Comment out ANY existing MACHINE definition (handles ??=, ?=, and =)
    sed -i 's/^MACHINE.*=/# &/' $CONF_FILE
    
    # 2. Append the new machine definition
    echo "MACHINE = \"$ARCH\"" >> $CONF_FILE
fi

# --- B. Configure SSH & Debug Features ---
# We check if ssh-server-dropbear is already in the file.
if ! grep -q "ssh-server-dropbear" $CONF_FILE; then
    echo "Enabling SSH Server..."
    
    # We append to EXTRA_IMAGE_FEATURES using +=
    # This keeps 'debug-tweaks' active (Critical for passwordless root login)
    echo 'EXTRA_IMAGE_FEATURES += "ssh-server-dropbear"' >> $CONF_FILE
fi

# --- OPTIMIZATION SECTION ---

# B. Share Downloads (Source Code)
# "If DL_DIR is not set, append it"
echo "Current directory: pwd: $(pwd)"
echo "CONF_FILE: $CONF_FILE"
if ! grep -q "^DL_DIR" $CONF_FILE; then
    echo "Configuring shared DL_DIR..."
    echo "DL_DIR ?= \"${DL_DIR}"\" >> $CONF_FILE
fi

# C. Share SState (Compiled Binaries)
# Only add if line starting with "SSTATE_DIR" is NOT found
if ! grep -q "^SSTATE_DIR" $CONF_FILE; then
    echo "Configuring shared SSTATE_DIR..."
    echo "SSTATE_DIR ?= \"${SSTATE_DIR}\"" >> $CONF_FILE
fi
# ----------------------------

# 4. Build
echo ">>> Starting Build for $ARCH..."
bitbake minimal-can-image