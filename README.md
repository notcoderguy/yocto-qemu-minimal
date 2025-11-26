# Yocto Minimal CAN Image for QEMU

This project provides a Yocto layer and configuration to build a minimal Linux image with CAN (Controller Area Network) support that can run in QEMU emulator.

## Features

- Minimal core image based on `core-image-minimal`
- CAN utilities (`can-utils`) for network management
- IP routing tools (`iproute2`) for setting up virtual CAN interfaces
- Kernel modules for CAN support
- SSH server for remote access
- QEMU-compatible configurations for x86-64, ARM, and AArch64

## Prerequisites

- Linux host system
- Git
- At least 50GB free disk space for build artifacts
- Basic Yocto dependencies (see [Yocto Project Quick Start](https://docs.yoctoproject.org/brief-yoctoprojectqs/index.html))

## Setup

1. Clone this repository:

   ```bash
   git clone https://github.com/notcoderguy/yocto-qemu-minimal.git
   cd yocto-qemu-minimal
   ```

2. Run the setup script to download Yocto dependencies:

   ```bash
   ./setup.sh
   ```

   This will clone Poky and Meta-OpenEmbedded repositories.

## Building

Build the image for your target architecture:

```bash
# For x86-64 (default)
./build.sh

# For ARM
./build.sh qemuarm

# For AArch64
./build.sh qemuarm64
```

The build process will:

- Initialize the build environment
- Add required layers
- Configure the build for the specified architecture
- Enable SSH server
- Build the `minimal-can-image`

## Cleaning

To clean build artifacts:

```bash
# Clean x86-64 build (default)
./clean.sh

# Clean ARM build
./clean.sh qemuarm

# Clean AArch64 build
./clean.sh qemuarm64

# Clean all builds
./clean.sh all
```

## SDK Generation

Generate the SDK for cross-compilation and development:

```bash
# For x86-64 (default)
./sdk.sh

# For ARM
./sdk.sh qemuarm

# For AArch64
./sdk.sh qemuarm64
```

This will generate an SDK installer in the build directory after building the image.

## Sourcing Environment

To source the Yocto build environment for manual bitbake commands:

```bash
# For x86-64 (default)
source ./source.sh

# For ARM
source ./source.sh qemuarm

# For AArch64
source ./source.sh qemuarm64
```

This sources the environment without building and changes your shell to the build directory. Ensure the build directory exists by running `./build.sh <arch>` first.

## Running in QEMU

After building, run the image in QEMU:

```bash
# For x86-64 (default)
./qemu.sh

# For ARM
./qemu.sh qemuarm

# For AArch64
./qemu.sh qemuarm64
```

The image will boot in nographic mode with SLIRP networking.

## CAN Interface Setup

Once the image is running in QEMU, you can set up a virtual CAN interface:

```bash
modprobe vcan
ip link add dev vcan0 type vcan
ip link set up vcan0
ip addr show vcan0
```

This will create a virtual CAN interface named `vcan0`.

You can then use `candump` and `cansend` tools to interact with the CAN interface.

```bash
candump vcan0 & # Start candump in the background
cansend vcan0 123#DEADBEEF # Send a CAN message
```

You will see the message in the candump output like this:

```bash
vcan0 123 [4] DE AD BE EF
```

You can also use the `can-utils` package to manage CAN interfaces.

## Optional: Shared Cache Setup

To speed up builds across multiple projects, create shared cache directories in your home cache:

```bash
mkdir -p ~/.cache/yocto/sstate-cache
mkdir -p ~/.cache/yocto/downloads
```

Then modify `./build.sh` to use these directories by default they are set to `./sstate-cache` and `./downloads`.:

```bash
DL_DIR = "${HOME}/.cache/yocto/downloads"
SSTATE_DIR = "${HOME}/.cache/yocto/sstate-cache"
```

## Project Structure

- `meta-minimal-can/`: Custom Yocto layer
  - `recipes-core/images/minimal-can-image.bb`: Image recipe
  - `recipes-kernel/linux/`: Kernel configuration for CAN support
- `build.sh`: Build script
- `clean.sh`: Clean script
- `sdk.sh`: SDK generation script
- `source.sh`: Environment sourcing script
- `qemu.sh`: QEMU run script
- `setup.sh`: Dependency setup script

## License

MIT License - see [LICENSE](LICENSE) file for details.
