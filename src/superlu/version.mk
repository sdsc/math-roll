ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-superlu_$(COMPILERNAME)_$(MPINAME)
VERSION        = 4.2
RELEASE        = 4
PKGROOT        = /opt/superlu/$(COMPILERNAME)/$(MPINAME)

SRC_SUBDIR     = superlu

SOURCE_NAME    = superlu_dist
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)_$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = SuperLU_DIST_$(SOURCE_VERSION)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
RPM.PREFIX     = $(PKGROOT)
