NAME               = superlu_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 3.2
RELEASE            = 0
RPM.EXTRAS         = "AutoReq: no"
PKGROOT            = /opt/superlu/$(ROLLCOMPILER)/$(ROLLMPI)/$(ROLLNETWORK)

SRC_SUBDIR         = superlu

SOURCE_NAME        = superlu
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tgz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TGZ_PKGS           = $(SOURCE_PKG)

