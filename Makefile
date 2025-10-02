SCRIPTS_DIR = scripts
FS_DIR = fs/buildroot
COMPOSITOR_DIR = os/compositor
INPUT_LIB_DIR = os/libs/input
GRAPHICS_LIB_DIR = os/libs/graphics

.PHONY: build qemu restore_conf setup_fs_conf build_compositor

build:
	./$(SCRIPTS_DIR)/build.sh

qemu:
	./$(SCRIPTS_DIR)/run_qemu.sh

restore_conf:
	./$(SCRIPTS_DIR)/restore_graphics_conf.sh

setup_fs_conf:
	cd $(FS_DIR) && make namios_defconfig

build_compositor:
	cd $(INPUT_LIB_DIR) && make
	cd $(GRAPHICS_LIB_DIR) && make
	cd $(COMPOSITOR_DIR) && make

kernel_menuconfig:
	cd core && make ARCH=arm64 menuconfig

buildroot_menuconfig:
	cd $(FS_DIR) && make menuconfig

clean:
	cd $(INPUT_LIB_DIR) && make clean
	cd $(GRAPHICS_LIB_DIR) && make clean
	cd $(COMPOSITOR_DIR) && make clean

distclean:
	cd core && make distclean
	cd $(FS_DIR) && make distclean

kernel:
	cd core && make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc)

rootfs:
	cd $(FS_DIR) && make -j$(nproc)

all: kernel rootfs

help:
	@echo "Доступные команды:"
	@echo "  make build         		- Полная сборка системы"
	@echo "  make qemu          		- Запуск в QEMU"
	@echo "  make kernel        		- Сборка только ядра"
	@echo "  make rootfs        		- Сборка только rootfs"
	@echo "  make all           		- Сборка ядра и rootfs"
	@echo "  make build_compositor		- Сборка композитора и библиотек"
	@echo "  make kernel_menuconfig 	- Настройка ядра"
	@echo "  make buildroot_menuconfig 	- Настройка Buildroot"
	@echo "  make clean         		- Очистка проектов"
	@echo "  make distclean     		- Полная очистка"