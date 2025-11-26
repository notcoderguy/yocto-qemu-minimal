SUMMARY = "A minimal image with CAN support for QEMU"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://../../../LICENSE;md5=6c387a4abe7f7486ff9f7ee2bf8f8854"

# Start with the standard core-image-minimal
require recipes-core/images/core-image-minimal.bb

# Add CAN tools and iproute2 (required to set up vcan interfaces)
IMAGE_INSTALL:append = " can-utils iproute2"

# Ensure kernel modules are installed so we can modprobe vcan
IMAGE_INSTALL:append = " kernel-modules"