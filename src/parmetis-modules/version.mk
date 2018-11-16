PACKAGE     = parmetis
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 7
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No\nObsoletes:sdsc-parmetis_gnu-modules,sdsc-parmetis_intel-modules,sdsc-parmetis_pgi-modules
RPM.PREFIX  = $(PKGROOT)
