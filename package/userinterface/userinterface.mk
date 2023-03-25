USERINTERFACE_VERSION = 91d31dffa163b7804b79877a029dd0f5a7a3a913
USERINTERFACE_SITE = $(call github,0x6c2d1f7b,qtui,$(USERINTERFACE_VERSION))
USERINTERFACE_DEPENDENCIES = qt5base qt5quickcontrols2
USERINTERFACE_PREFIX = $(TARGET_DIR)/usr

MYQMAKE = $(TOPDIR)/output/host/usr/bin/qmake

define USERINTERFACE_CONFIGURE_CMDS
	(cd $(@D) && $(MYQMAKE) -r PREFIX=$(USERINTERFACE_PREFIX))
endef

define USERINTERFACE_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define USERINTERFACE_INSTALL_TARGET_CMDS
        (cd $(@D); cp oobui_vertical $(USERINTERFACE_PREFIX)/bin)

endef

$(eval $(generic-package))

