# Cardinal sprcific build properties
ADDITIONAL_BUILD_PROPERTIES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    cardinal.ota.version=$(CARDINAL_MOD_VERSION) \
    ro.cardinal.version=$(CARDINAL_VERSION_CODENAME) \
    ro.modversion=$(CARDINAL_MOD_VERSION) \
    ro.cardinal.buildtype=$(CARDINAL_BUILD_TYPE)
