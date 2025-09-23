APPEND="\"console=tty0 root=/dev/vda rw video=1920x1080\""
MACHINE="virt,gic-version=3"
CPU="cortex-a57"


while [ "$#" -gt 0 ]; do
    case "$1" in
    -a|--append)
        echo "Argument -a found with value: $2"
        shift # Consume the option
        shift # Consume the value
        ;;
    -m|--machine)
        echo "Argument -m found with value: $2"
        shift # Consume the option
        shift
        ;;
    -c|--cpu)
        echo "Argument -c found with value: $2"
        shift # Consume the option
        shift
        ;;
    )
        echo "Unknown argument: $1"
        shift # Consume the unknown argument
        ;;
    esac
done

qemu-system-aarch64 \
    -machine $MACHINE \
    -cpu $CPU \
    -m 2G \
    -kernel $(pwd)/core/arch/arm64/boot/Image \
    -drive file=$(pwd)/fs/buildroot/output/images/rootfs.ext4,if=none,format=raw,id=hd0 \
    -device virtio-blk-device,drive=hd0 \
    -netdev user,id=net0 \
    -device virtio-net-device,netdev=net0 \
    -append $APPEND \
    -device virtio-gpu-pci,xres=1920,yres=1080 \
    -display gtk \
    -serial stdio \
    -fsdev local,security_model=none,id=fsdev0,path=$(pwd)/core \
    -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=hostshare \
    -device qemu-xhci,id=xhci \
    -device usb-tablet,bus=xhci.0 \
    -device usb-kbd,bus=xhci.0