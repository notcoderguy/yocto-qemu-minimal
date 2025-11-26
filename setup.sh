#!/bin/bash
# setup.sh - Download dependencies

# Define Branch (Keep everyone on the same version)
BRANCH="scarthgap"

echo ">>> Setting up Yocto Environment ($BRANCH)..."

# Clone Poky
if [ ! -d "poky" ]; then
    echo "Cloning Poky..."
    git clone -b $BRANCH git://git.yoctoproject.org/poky
else
    echo "Poky already exists."
fi

# Clone Meta-OpenEmbedded
if [ ! -d "meta-openembedded" ]; then
    echo "Cloning Meta-OpenEmbedded..."
    git clone -b $BRANCH git://git.openembedded.org/meta-openembedded
else
    echo "Meta-OpenEmbedded already exists."
fi

echo ">>> Setup complete."