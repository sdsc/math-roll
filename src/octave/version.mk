ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
FIRSTCOMPILER := $(firstword $(ROLLCOMPILER))
COMPILERNAME := $(firstword $(subst /, ,$(FIRSTCOMPILER)))
# Note: presently only able to compile with gnu compiler
ifneq ("$(COMPILERNAME)", "gnu")
  FIRSTCOMPILER := gnu
  COMPILERNAME := gnu
endif

# ROLLNETWORK/MPI only used for locating fftw/hdf5 modulefiles
ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif
ifndef ROLLMPI
  ROLLMPI = openmpi
endif

NAME               = octave_$(COMPILERNAME)
VERSION            = 3.6.4
RELEASE            = 1
RPM.EXTRAS         = "AutoReq: no"
PKGROOT            = /opt/octave

SRC_SUBDIR         = octave

SOURCE_NAME        = octave
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG)
