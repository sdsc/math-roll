ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLMPI
  ROLLMPI = rocks-openmpi
endif
MPINAME := $(firstword $(subst /, ,$(ROLLMPI)))

ifndef ROLLPY
  ROLLPY = python
endif

NAME           = trilinos_$(COMPILERNAME)_$(MPINAME)
VERSION        = 11.10.2
RELEASE        = 1
PKGROOT        = /opt/trilinos/$(COMPILERNAME)/$(MPINAME)

SRC_SUBDIR     = trilinos

SOURCE_NAME    = trilinos
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION)-Source.$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

SWIG_NAME      = swig
SWIG_SUFFIX    = tar.gz
SWIG_VERSION   = 2.0.3
SWIG_PKG       = $(SWIG_NAME)-$(SWIG_VERSION).$(SWIG_SUFFIX)
SWIG_DIR       = $(SWIG_PKG:%.$(SWIG_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG) $(SWIG_PKG)

RPM.EXTRAS     = AutoReq:No
