USERINTERFACE_VERSION = 108ac9cb9ac85bc9270891f9308bfb63f936c05f
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
        (cd $(@D); cp qml-july-02 $(USERINTERFACE_PREFIX)/bin)

endef

$(eval $(generic-package))

