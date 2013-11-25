NAME               = lapack_$(ROLLCOMPILER)
VERSION            = 3.4.2
RELEASE            = 0
RPM.EXTRAS         = "AutoReq: no"
PKGROOT            = /opt/lapack/$(ROLLCOMPILER)

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
