PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)
DEBUG=0

SUBPROJECTS += tweak

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk