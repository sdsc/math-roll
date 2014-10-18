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
VERSION        = 3.3
RELEASE        = 0
PKGROOT        = /opt/superlu/$(COMPILERNAME)/$(ROLLMPI)/$(ROLLNETWORK)

SRC_SUBDIR     = superlu

SOURCE_NAME    = superlu_dist
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)_$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = SuperLU_DIST_$(SOURCE_VERSION)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
