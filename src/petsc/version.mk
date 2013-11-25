NAME               = petsc_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 3.3.p5
RELEASE            = 1
RPM.EXTRAS         = "AutoReq: no"
PKGROOT            = /opt/petsc/$(ROLLCOMPILER)/$(ROLLMPI)/$(ROLLNETWORK)

SRC_SUBDIR         = petsc

SOURCE_NAME        = petsc
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG)
