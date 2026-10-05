ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KYREXIPAA
KYREXIPAA_FILES = kyrexipaa.xm
KYREXIPAA_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-error
KYREXIPAA_FRAMEWORKS = UIKit Foundation
KYREXIPAA_RESOURCE_DIRS = .

include $(THEOS_MAKE_PATH)/tweak.mk
