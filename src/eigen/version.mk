ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
FIRSTCOMPILER = $(firstword $(ROLLCOMPILER))
COMPILERNAME := $(firstword $(subst /, ,$(FIRSTCOMPILER)))

NAME               = eigen_$(COMPILERNAME)
VERSION            = 3.2.1
RELEASE            = 0
PKGROOT            = /opt/eigen
RPM.EXTRAS         = AutoReq:No

SRC_SUBDIR         = eigen

SOURCE_NAME        = eigen
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG)
