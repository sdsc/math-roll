NAME           = sdsc-eigen
VERSION        = 3.2.7
RELEASE        = 1
PKGROOT        = /opt/eigen

SRC_SUBDIR     = eigen

SOURCE_NAME    = eigen
SOURCE_SUFFIX  = tar.bz2
SOURCE_VERSION = $(VERSION)
SOURCE_PKG     = eigen-eigen-b30b87236a1b.$(SOURCE_SUFFIX)
SOURCE_DIR     = eigen-eigen-b30b87236a1b

TAR_BZ2_PKGS    = $(SOURCE_PKG)

RPM.EXTRAS     = AutoReq:No
RPM.PREFIX     = $(PKGROOT)
