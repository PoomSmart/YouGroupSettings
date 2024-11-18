TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = YouTube
PACKAGE_VERSION = 1.0.2
ARCHS = arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouGroupSettings

$(TWEAK_NAME)_FILES = Tweak.x
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
