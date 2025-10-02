NAMIOS_COMPOSITOR_VERSION = 1.0
NAMIOS_COMPOSITOR_SITE = $(TOPDIR)/../../os/compositor
NAMIOS_COMPOSITOR_SITE_METHOD = local
NAMIOS_COMPOSITOR_DEPENDENCIES = namios-graphics-lib namios-input-lib

define NAMIOS_COMPOSITOR_BUILD_CMDS
    $(MAKE) CC="$(TARGET_CC)" \
        CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include" \
        LDFLAGS="$(TARGET_LDFLAGS) $(STAGING_DIR)/usr/lib/libinput.a $(STAGING_DIR)/usr/lib/libgraphics.a -ldrm" \
        -C $(@D) clean all
endef

define NAMIOS_COMPOSITOR_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0755 $(@D)/namios-compositor $(TARGET_DIR)/usr/bin/namios-compositor
endef

$(eval $(generic-package))