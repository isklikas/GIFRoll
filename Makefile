DEBUG = 0
GO_EASY_ON_ME = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PhotoGIFs
PhotoGIFs_FILES = Tweak.xm UIImage+animatedGIF.m
PhotoGIFs_FRAMEWORKS = UIKit ImageIO
PhotoGIFs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += photogifsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
