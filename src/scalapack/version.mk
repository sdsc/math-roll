ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = sdsc-scalapack_$(COMPILERNAME)_$(MPINAME)
VERSION        = 2.0.2
RELEASE        = 6
PKGROOT        = /opt/scalapack/$(COMPILERNAME)/$(MPINAME)

SRC_SUBDIR     = scalapack

SOURCE_NAME    = scalapack
SOURCE_SUFFIX  = tgz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS       = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
RPM.PREFIX     = $(PKGROOT)
