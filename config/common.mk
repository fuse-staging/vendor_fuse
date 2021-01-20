# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= FuseOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/fuse/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/fuse/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/fuse/prebuilt/common/bin/50-fuse.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-fuse.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/fuse/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/fuse/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/fuse/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/fuse/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# fuse-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/fuse/config/permissions/fuse-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/fuse-sysconfig.xml

# Copy all fuse-specific init rc files
$(foreach f,$(wildcard vendor/fuse/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/fuse/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# Include AOSP audio files
include vendor/fuse/config/aosp_audio.mk

# Include fuse audio files
include vendor/fuse/config/fuse_audio.mk


# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Bootanimation
PRODUCT_PACKAGES += \
    bootanimation.zip

# AOSP packages
PRODUCT_PACKAGES += \
    Terminal

# Themes
PRODUCT_PACKAGES += \
    ThemePicker

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Bootanimation
include vendor/fuse/bootanimation/bootanimation.mk

# Versioning
include vendor/fuse/config/versioning.mk

# Extra tools in fuse
PRODUCT_PACKAGES += \
    7z \
    awk \
    bash \
    bzip2 \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    nano \
    pigz \
    setcap \
    unrar \
    vim \
    wget \
    zip

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/fuse/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/fuse/overlay/common

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/fuse/config/partner_gms.mk
