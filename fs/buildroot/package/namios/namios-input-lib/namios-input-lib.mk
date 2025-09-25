NAMIOS_INPUT_LIB_VERSION = 1.0.0
NAMIOS_INPUT_LIB_SITE = $(TOPDIR)/../../../../os/libs/input
NAMIOS_INPUT_LIB_SITE_METHOD = local
NAMIOS_INPUT_LIB_INSTALL_STAGING = YES

define NAMIOS_INPUT_LIB_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" -C $(@D) all
endef

define NAMIOS_INPUT_LIB_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libinput.a $(STAGING_DIR)/usr/lib/
	$(INSTALL) -D -m 0644 $(@D)/input.h $(STAGING_DIR)/usr/include/
endef

define NAMIOS_INPUT_LIB_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libinput.a $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 0644 $(@D)/input.h $(TARGET_DIR)/usr/include/
endef

$(eval $(generic-package))