ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
COMPILERNAME := $(firstword $(subst /, ,$(ROLLCOMPILER)))

NAME               = lapack_$(COMPILERNAME)
VERSION            = 3.5.0
RELEASE            = 1
RPM.EXTRAS         = "AutoReq: no"
PKGROOT            = /opt/lapack/$(COMPILERNAME)

SRC_SUBDIR         = lapack

SOURCE_NAME        = lapack
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tgz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

BLAS_NAME          = blas
BLAS_PKG           = $(BLAS_NAME).$(SOURCE_SUFFIX)
BLAS_DIR           = $(BLAS_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS           = $(SOURCE_PKG) $(BLAS_PKG)
