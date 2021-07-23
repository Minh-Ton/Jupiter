TARGET := iphone:clang::13.3
ARCHS = arm64 arm64e
SDKVERSION = 13.3
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Jupiter

Jupiter_FILES = $(wildcard *.xm)
Jupiter_CFLAGS = -fobjc-arc
Jupiter_PRIVATE_FRAMEWORKS = SpringBoardFoundation Weather WeatherUI

# YOU MAY EDIT THIS TO SUIT YOUR THEOS INSTALLATION
Jupiter_LDFLAGS = $(THEOS)/sdks/iPhoneOS13.3.sdk/System/Library/PrivateFrameworks/WeatherUI.framework/WeatherUI.tbd

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
