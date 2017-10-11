ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

VERSION        = 1.16
NAME           = sdsc-gsl-$(VERSION)_$(COMPILERNAME)
RELEASE        = 1
PKGROOT        = /opt/gsl/$(VERSION)/$(COMPILERNAME)

SRC_SUBDIR     = gsl

SOURCE_NAME    = gsl
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
RPM.PREFIX     = $(PKGROOT)
