include vendor/fuse/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/fuse/config/BoardConfigQcom.mk
endif

include vendor/fuse/config/BoardConfigSoong.mk
