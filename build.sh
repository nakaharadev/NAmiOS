#!/bin/bash

# Переходим в директорию с ядром
cd core

# Экспортируем переменные ТОЛЬКО на время выполнения этого скрипта
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-


echo "Building kernel with ARCH=$ARCH and CROSS_COMPILE=$CROSS_COMPILE..."

# Запускаем сборку. Используем все ядра.
make -j"$(nproc)"