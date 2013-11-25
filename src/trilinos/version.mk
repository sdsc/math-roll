NAME               = trilinos_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
VERSION            = 11.0.3
RELEASE            = 0
RPM.EXTRAS         = "AutoReq: no"
PKGROOT            = /opt/trilinos/$(ROLLCOMPILER)/$(ROLLMPI)/$(ROLLNETWORK)

SRC_SUBDIR         = trilinos

SOURCE_NAME        = trilinos
SOURCE_VERSION     = $(VERSION)
SOURCE_SUFFIX      = tar.gz
SOURCE_PKG         = $(SOURCE_NAME)-$(SOURCE_VERSION).$(SOURCE_SUFFIX)
SOURCE_DIR         = $(SOURCE_PKG:%.$(SOURCE_SUFFIX)=%)

SWIG_NAME          = swig
SWIG_VERSION       = 2.0.3
SWIG_PKG           = $(SWIG_NAME)-$(SWIG_VERSION).$(SOURCE_SUFFIX)
SWIG_DIR           = $(SWIG_PKG:%.$(SOURCE_SUFFIX)=%)

TAR_GZ_PKGS        = $(SOURCE_PKG) $(SWIG_PKG)

