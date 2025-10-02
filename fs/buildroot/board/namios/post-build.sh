#!/bin/sh

# Make init script executable
if [ -f "${TARGET_DIR}/etc/init.d/S99namios" ]; then
    chmod +x "${TARGET_DIR}/etc/init.d/S99namios"
fi

# Ensure compositor is executable
chmod +x "${TARGET_DIR}/usr/bin/namios-compositor"

# Create necessary directories
mkdir -p "${TARGET_DIR}/var/run"