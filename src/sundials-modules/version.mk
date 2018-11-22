PACKAGE     = sundials
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 8
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

RPM.EXTRAS  = AutoReq:No\nObsoletes:sdsc-sundials_gnu-modules,sdsc-sundials_intel-modules,sdsc-sundials_pgi-modules
RPM.PREFIX  = $(PKGROOT)
