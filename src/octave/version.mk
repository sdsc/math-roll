ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
FIRSTCOMPILER := $(firstword $(ROLLCOMPILER))
COMPILERNAME := $(firstword $(subst /, ,$(FIRSTCOMPILER)))

# ROLLNETWORK/MPI only used for locating fftw/hdf5 modulefiles

ifndef ROLLMPI
  ROLLMPI = openmpi
endif
FIRSTMPI := $(firstword $(ROLLMPI))

ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif
FIRSTNETWORK := $(firstword $(ROLLNETWORK))

NAME           = octave_$(COMPILERNAME)
VERSION        = 3.8.2
RELEASE        = 0
PKGROOT        = /opt/octave

SRC_SUBDIR     = octave

SOURCE_NAME    = octave
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
