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

NAME           = superlu_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION        = 3.2
RELEASE        = 2
PKGROOT        = /opt/superlu/$(COMPILERNAME)/$(ROLLMPI)/$(ROLLNETWORK)

SRC_SUBDIR     = superlu

SOURCE_NAME    = superlu
SOURCE_SUFFIX  = tgz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS       = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
