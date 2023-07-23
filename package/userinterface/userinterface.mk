USERINTERFACE_VERSION = 4b54b3e2357f0d0b522bdd719cac1769e3a9ed12
USERINTERFACE_SITE = $(call github,resiliencetheatre,qtui,$(USERINTERFACE_VERSION))
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
        (cd $(@D); cp oobcomm $(USERINTERFACE_PREFIX)/bin)

endef

$(eval $(generic-package))

