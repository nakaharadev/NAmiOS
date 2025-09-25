NAMIOS_COMPOSITOR_VERSION = 1.0.0
NAMIOS_COMPOSITOR_SITE = $(TOPDIR)/../../../../os/compositor
NAMIOS_COMPOSITOR_SITE_METHOD = local
NAMIOS_COMPOSITOR_DEPENDENCIES = namios-graphics-lib namios-input-lib

define NAMIOS_COMPOSITOR_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" -C $(@D) all
endef

define NAMIOS_COMPOSITOR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/namios-compositor $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 0755 $(@D)/S99namios $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))