#
# This policy configuration will be used by all products that
# inherit from Cardinal
#

BOARD_PLAT_PUBLIC_SEPOLICY_DIR += \
    vendor/cardinal/sepolicy/common/public

BOARD_PLAT_PRIVATE_SEPOLICY_DIR += \
    vendor/cardinal/sepolicy/common/private

BOARD_SEPOLICY_DIRS += \
    vendor/cardinal/sepolicy/common/vendor
