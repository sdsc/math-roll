ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = openmpi
endif

ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif

NAME           = slepc_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION        = 3.5.2
RELEASE        = 0
PKGROOT        = /opt/slepc/$(COMPILERNAME)/$(ROLLMPI)/$(ROLLNETWORK)

SRC_SUBDIR     = slepc

SOURCE_NAME    = slepc
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
