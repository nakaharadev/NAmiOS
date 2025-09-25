#!/bin/bash
echo "=== Restoring Graphics Kernel Configuration ==="

cd ~/Desktop/Dev/NAmiOS/core

# Базовый ARM64 config

# Ключевые опции для графики
./scripts/config --enable CONFIG_FB
./scripts/config --enable CONFIG_FB_SIMPLE
./scripts/config --enable CONFIG_FRAMEBUFFER_CONSOLE
./scripts/config --enable CONFIG_FB_EFI

# DRM система
./scripts/config --enable CONFIG_DRM
./scripts/config --module CONFIG_DRM_KMS_HELPER
./scripts/config --module CONFIG_DRM_VIRTIO_GPU

# VirtIO
./scripts/config --enable CONFIG_VIRTIO
./scripts/config --enable CONFIG_VIRTIO_PCI
./scripts/config --enable CONFIG_VIRTIO_BALLOON
./scripts/config --enable CONFIG_VIRTIO_BLK
./scripts/config --enable CONFIG_VIRTIO_NET

# Ввод
./scripts/config --enable CONFIG_INPUT
./scripts/config --enable CONFIG_INPUT_EVDEV
./scripts/config --enable CONFIG_INPUT_KEYBOARD
./scripts/config --enable CONFIG_INPUT_MOUSEDEV

# Файловые системы
./scripts/config --enable CONFIG_EXT4_FS
./scripts/config --enable CONFIG_PROC_FS
./scripts/config --enable CONFIG_SYSFS

# Консоль
./scripts/config --enable CONFIG_VT
./scripts/config --enable CONFIG_VT_CONSOLE
./scripts/config --enable CONFIG_SERIAL_AMBA_PL011
./scripts/config --enable CONFIG_SERIAL_AMBA_PL011_CONSOLE

echo "✅ Graphics configuration restored!"
echo "Review settings with: make ARCH=arm64 menuconfig"
echo "Build with: ./scripts/build-safe.sh"