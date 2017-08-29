PACKAGE     = gsl
CATEGORY    = applications

NAME        = sdsc-$(PACKAGE)-modules
RELEASE     = 6
PKGROOT     = /opt/modulefiles/$(CATEGORY)/$(PACKAGE)

VERSION_SRC = $(REDHAT.ROOT)/src/$(PACKAGE)/version.mk
VERSION_INC = version.inc
include $(VERSION_INC)

EXTRA_MODULE_VERSIONS = 1.16

RPM.EXTRAS  = AutoReq:No\nObsoletes:sdsc-gsl_gnu-modules,sdsc-gsl_intel-modules,sdsc-gsl_pgi-modules
