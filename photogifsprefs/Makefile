include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = PhotoGifsPrefs
PhotoGifsPrefs_FILES = SETRootListController.m PFHeaderCell.mm
PhotoGifsPrefs_INSTALL_PATH = /Library/PreferenceBundles
PhotoGifsPrefs_FRAMEWORKS = UIKit Photos
PhotoGifsPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PhotoGifsPrefs.plist$(ECHO_END)
