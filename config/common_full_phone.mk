# Inherit full common Lineage stuff
$(call inherit-product, vendor/fuse/config/common_full.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include Lineage LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/fuse/overlay/dictionaries

$(call inherit-product, vendor/fuse/config/telephony.mk)
