ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

NAME           = petsc_$(COMPILERNAME)_$(MPINAME)
VERSION        = 3.5.2
RELEASE        = 1
PKGROOT        = /opt/petsc/$(COMPILERNAME)/$(MPINAME)

SRC_SUBDIR     = petsc

SOURCE_NAME    = petsc
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
