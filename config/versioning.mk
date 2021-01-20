# Versioning System
FUSE_BUILD_VERSION = 11
FUSE_BUILD_TYPE ?= UNOFFICIAL
FUSE_BUILD_MAINTAINER ?= Unofficial maintainer
FUSE_BUILD_DONATE_URL ?= https://www.paypal.me/
FUSE_BUILD_SUPPORT_URL ?= https://t.me/

ifeq ($(FUSE_BUILD_TYPE), OFFICIAL)
  OFFICIAL_DEVICES = $(shell cat vendor/fuse/fuse.devices)
  FOUND_DEVICE =  $(filter $(FUSE_BUILD), $(OFFICIAL_DEVICES))
    ifeq ($(FOUND_DEVICE),$(FUSE_BUILD))
      FUSE_BUILD_TYPE := OFFICIAL
    else
      FUSE_BUILD_TYPE := UNOFFICIAL
      $(error Device is not official "$(FUSE_BUILD)")
    endif
endif

# System version
TARGET_PRODUCT_SHORT := $(subst fuse_,,$(FUSE_BUILD_TYPE))

FUSE_DATE_YEAR := $(shell date -u +%Y)
FUSE_DATE_MONTH := $(shell date -u +%m)
FUSE_DATE_DAY := $(shell date -u +%d)
FUSE_DATE_HOUR := $(shell date -u +%H)
FUSE_DATE_MINUTE := $(shell date -u +%M)


FUSE_BUILD_DATE := $(FUSE_DATE_YEAR)$(FUSE_DATE_MONTH)$(FUSE_DATE_DAY)-$(FUSE_DATE_HOUR)$(FUSE_DATE_MINUTE)
FUSE_BUILD_FINGERPRINT := FuseOS/$(FUSE_VERSION)/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(FUSE_BUILD_DATE)
FUSE_VERSION := FuseOS-$(FUSE_BUILD_VERSION)-$(FUSE_BUILD_TYPE)-$(FUSE_BUILD)-$(FUSE_BUILD_DATE)

PRODUCT_GENERIC_PROPERTIES += \
  ro.fuse.device=$(FUSE_BUILD) \
  ro.fuse.version=$(FUSE_VERSION) \
  ro.fuse.build.version=$(FUSE_BUILD_VERSION) \
  ro.fuse.build.type=$(FUSE_BUILD_TYPE) \
  ro.fuse.build.date=$(FUSE_BUILD_DATE) \
  ro.fuse.build.fingerprint=$(FUSE_BUILD_FINGERPRINT) \
  ro.fuse.build.maintainer=$(FUSE_BUILD_MAINTAINER) \
  ro.fuse.build.donate_url=$(FUSE_BUILD_DONATE_URL) \
  ro.fuse.build.support_url=$(FUSE_BUILD_SUPPORT_URL)