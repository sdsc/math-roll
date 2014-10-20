ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
FIRSTCOMPILER := $(firstword $(ROLLCOMPILER))
COMPILERNAME := $(firstword $(subst /, ,$(FIRSTCOMPILER)))

# ROLLMPI only used for locating fftw/hdf5 modulefiles
ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
FIRSTMPI := $(firstword $(ROLLMPI))

NAME           = octave_$(COMPILERNAME)
VERSION        = 3.8.2
RELEASE        = 1
PKGROOT        = /opt/octave

SRC_SUBDIR     = octave

SOURCE_NAME    = octave
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
