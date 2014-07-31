ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif

ifndef ROLLMPI
  ROLLMPI = openmpi
endif

ifndef ROLLPY
  ROLLPY = python
endif

NAME               = trilinos_$(COMPILERNAME)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 11.4.3
RELEASE            = 1
RPM.EXTRAS         = "AutoReq: no"
PKGROOT            = /opt/trilinos/$(COMPILERNAME)/$(ROLLMPI)/$(ROLLNETWORK)

SRC_SUBDIR         = trilinos

SOURCE_NAME        = trilinos
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION)-Source.$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

SWIG_NAME          = swig
SWIG_VERSION       = 2.0.3
SWIG_PKG           = $(SWIG_NAME)-$(SWIG_VERSION).$(SOURCE_SUFFIX)
SWIG_DIR           = $(SWIG_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG) $(SWIG_PKG)

