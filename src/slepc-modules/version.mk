PACKAGE     = slepc
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 6
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No\nObsoletes:sdsc-slepc_gnu-modules,sdsc-slepc_intel-modules,sdsc-slepc_pgi-modules
RPM.PREFIX  = $(PKGROOT)
