ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

NAME           = lapack_$(COMPILERNAME)
VERSION        = 3.5.0
RELEASE        = 1
PKGROOT        = /opt/lapack/$(COMPILERNAME)

SRC_SUBDIR     = lapack

SOURCE_NAME    = lapack
SOURCE_SUFFIX  = tgz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

BLAS_NAME      = blas
BLAS_SUFFIX    = tgz
BLAS_PKG       = $(BLAS_NAME).$(BLAS_SUFFIX)
BLAS_DIR       = $(BLAS_PKG:%.$(BLAS_SUFFIX)=%)

TGZ_PKGS       = $(SOURCE_PKG) $(BLAS_PKG)

RPM.EXTRAS     = AutoReq:No
