OOBUIVERTICAL_VERSION = 91d31dffa163b7804b79877a029dd0f5a7a3a913
OOBUIVERTICAL_SITE = $(call github,0x6c2d1f7b,qtui,$(OOBUIVERTICAL_VERSION))
OOBUIVERTICAL_DEPENDENCIES = qt5base qt5quickcontrols2
OOBUIVERTICAL_PREFIX = $(TARGET_DIR)/usr

MYQMAKE = $(TOPDIR)/output/host/usr/bin/qmake

define OOBUIVERTICAL_CONFIGURE_CMDS
	(cd $(@D) && $(MYQMAKE) -r PREFIX=$(OOBUIVERTICAL_PREFIX))
endef

define OOBUIVERTICAL_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define OOBUIVERTICAL_INSTALL_TARGET_CMDS
        (cd $(@D); cp oobui_vertical $(OOBUIVERTICAL_PREFIX)/bin)

endef

$(eval $(generic-package))

