#!/bin/bash

set -e

echo "=== Build System for NAmiOS ==="

# Проверка необходимых файлов
if [ ! -f "kernel/.config" ]; then
    echo "❌ Kernel .config not found. Please run 'make menuconfig' in core/"
    exit 1
fi

if [ ! -f "buildroot/.config" ]; then
    echo "❌ Buildroot .config not found. Configuring..."
    cd buildroot
    make namios_defconfig
    cd ..
fi

echo "✅ Kernel .config found"
echo "✅ Buildroot .config found"

# Сборка ядра
echo "=== Building kernel ==="
cd kernel
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
cd ..

# Сборка rootfs
echo "=== Building rootfs ==="
cd buildroot
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)
cd ..

echo "=== Build complete ==="
echo "Kernel: kernel/arch/arm64/boot/Image"
echo "Rootfs: buildroot/output/images/rootfs.ext4"