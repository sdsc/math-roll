NAME               = eigen_$(ROLLCOMPILER)
VERSION            = 3.1.3
RELEASE            = 0
PKGROOT            = /opt/eigen/$(ROLLCOMPILER)
RPM.EXTRAS         = AutoReq:No

SRC_SUBDIR         = eigen

SOURCE_NAME        = eigen
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG)
