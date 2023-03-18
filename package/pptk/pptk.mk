################################################################################
#
# PPTK
#
################################################################################

PPTK_VERSION = 0107cf984fe5d04dc876a18139cc0c52d6bd6046
PPTK_SITE = $(call github,Dejvino,pinephone-toolkit,$(PPTK_VERSION))
PPTK_INSTALL_STAGING = YES
PPTK_LICENSE = APACHE-2.0
PPTK_LICENSE_FILES = COPYING
PPTK_PREFIX = $(TARGET_DIR)/usr

define PPTK_INSTALL_TARGET_CMDS
        (cd $(@D); cp build/pptk-backlight build/pptk-cpu-sleep  build/pptk-led build/pptk-vibrate $(PPTK_PREFIX)/bin)
endef


$(eval $(meson-package))
