NAMIOS_GRAPHICS_LIB_VERSION = 1.0
NAMIOS_GRAPHICS_LIB_SITE = $(TOPDIR)/../../os/libs/graphics
NAMIOS_GRAPHICS_LIB_SITE_METHOD = local
NAMIOS_GRAPHICS_LIB_INSTALL_STAGING = YES

define NAMIOS_GRAPHICS_LIB_BUILD_CMDS
    $(MAKE) CC="$(TARGET_CC)" -C $(@D) all
endef

define NAMIOS_GRAPHICS_LIB_INSTALL_STAGING_CMDS
    $(INSTALL) -D -m 0644 $(@D)/graphics.h $(STAGING_DIR)/usr/include/namios/graphics.h
    $(INSTALL) -D -m 0644 $(@D)/libgraphics.a $(STAGING_DIR)/usr/lib/libgraphics.a
endef

define NAMIOS_GRAPHICS_LIB_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 0644 $(@D)/libgraphics.a $(TARGET_DIR)/usr/lib/libgraphics.a
endef

$(eval $(generic-package))