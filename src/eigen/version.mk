NAME           = eigen
VERSION        = 3.2.2
RELEASE        = 0
PKGROOT        = /opt/eigen

SRC_SUBDIR     = eigen

SOURCE_NAME    = eigen
SOURCE_SUFFIX  = tar.gz
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR     = eigen-eigen-1306d75b4a21

TAR_GZ_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
