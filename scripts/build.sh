#!/bin/bash

set -e

echo "=== Build System for NAmiOS ==="

# Проверка необходимых файлов
if [ ! -f "core/.config" ]; then
    echo "❌ Kernel .config not found. Please run 'make menuconfig' in core/"
    exit 1
fi

if [ ! -f "fs/buildroot/.config" ]; then
    echo "❌ Buildroot .config not found. Configuring..."
    cd fs/buildroot
    make namios_defconfig
    cd ../..
fi

echo "✅ Kernel .config found"
echo "✅ Buildroot .config found"

# Сборка ядра
echo "=== Building kernel ==="
cd core
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
cd ..

# Сборка rootfs
echo "=== Building rootfs ==="
cd fs/buildroot
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
cd ../..

echo "=== Build complete ==="
echo "Kernel: core/arch/arm64/boot/Image"
echo "Rootfs: fs/buildroot/output/images/rootfs.ext4"