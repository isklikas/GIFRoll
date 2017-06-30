include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PhotoGIFs
PhotoGIFs_FILES = Tweak.xm UIImage+animatedGIF.m
PhotoGIFs_FRAMEWORKS = UIKit ImageIO
PhotoGIFs_CFLAGS = -fobjc-arc -Wno-deprecated-declarations  -Wno-unused-variable

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += photogifsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
