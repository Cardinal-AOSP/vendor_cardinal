#
# This policy configuration will be used by all qcom products
# that inherit from Cardinal
#

BOARD_SEPOLICY_DIRS += \
    vendor/cardinal/sepolicy/qcom/common \
    vendor/cardinal/sepolicy/qcom/$(TARGET_BOARD_PLATFORM)
