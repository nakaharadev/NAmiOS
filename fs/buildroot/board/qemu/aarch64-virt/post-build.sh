cp ${BUILD_DIR}/namios-compositor-1.0/namios-compositor ${TARGET_DIR}/usr/bin/
cp ${BUILD_DIR}/namios-graphics-lib-1.0/libgraphics.a ${TARGET_DIR}/usr/lib/
cp ${BUILD_DIR}/namios-input-lib-1.0/libinput.a ${TARGET_DIR}/usr/lib/

# Убедимся, что файлы исполняемые
chmod 755 ${TARGET_DIR}/usr/bin/namios-compositor