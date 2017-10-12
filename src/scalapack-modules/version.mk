PACKAGE     = scalapack
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 6
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No\nObsoletes:sdsc-scalapack_gnu-modules,sdsc-scalapack_intel-modules,sdsc-scalapack_pgi-modules
RPM.PREFIX  = $(PKGROOT)
