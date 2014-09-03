NAME           = eigen
VERSION        = 3.2.1
RELEASE        = 1
PKGROOT        = /opt/eigen

SRC_SUBDIR     = eigen

SOURCE_NAME    = eigen
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
