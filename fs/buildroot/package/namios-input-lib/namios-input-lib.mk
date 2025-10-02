# package/namios/namios-input-lib/namios-input-lib.mk
NAMIOS_INPUT_LIB_VERSION = 1.0
NAMIOS_INPUT_LIB_SITE = $(TOPDIR)/../../os/libs/input
NAMIOS_INPUT_LIB_SITE_METHOD = local
NAMIOS_INPUT_LIB_INSTALL_STAGING = YES
NAMIOS_INPUT_LIB_DEPENDENCIES = libinput

define NAMIOS_INPUT_LIB_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" -C $(@D) all
endef

define NAMIOS_INPUT_LIB_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/input.h $(STAGING_DIR)/usr/include/namios/input.h
	$(INSTALL) -D -m 0644 $(@D)/libinput.a $(STAGING_DIR)/usr/lib/libinput.a
endef

define NAMIOS_INPUT_LIB_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libinput.a $(TARGET_DIR)/usr/lib/libinput.a
endef

$(eval $(generic-package))