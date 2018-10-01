NAME           = sdsc-eigen
VERSION        = 3.3.5
RELEASE        = 0
PKGROOT        = /opt/eigen

SRC_SUBDIR     = eigen

SOURCE_NAME    = eigen
SOURCE_SUFFIX  = tar.bz2
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = eigen-eigen-b3f3d4950030.$(SOURCE_SUFFIX)
SOURCE_DIR     = eigen-eigen-b3f3d4950030

TAR_BZ2_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
RPM.PREFIX     = $(PKGROOT)
