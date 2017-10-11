#
# $Id$
#
# @Copyright@
#
#                               Rocks(r)
#                        www.rocksclusters.org
#                        version 7.0 (Manzanita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice unmodified and in its entirety, this list of conditions and the
# following disclaimer in the documentation and/or other materials provided
# with the distribution.
#
# 3. All advertising and press materials, printed or electronic, mentioning
# features or use of this software must display the following acknowledgement:
#
#       "This product includes software developed by the Rocks(r)
#       Cluster Group at the San Diego Supercomputer Center at the
#       University of California, San Diego and its contributors."
#
# 4. Except as permitted for the purposes of acknowledgment in paragraph 3,
# neither the name or logo of this software nor the names of its
# authors may be used to endorse or promote products derived from this
# software without specific prior written permission.  The name of the
# software includes the following terms, and any derivatives thereof:
# "Rocks", "Rocks Clusters", and "Avalanche Installer".  For licensing of
# the associated name, interested parties should contact Technology
# Transfer & Intellectual Property Services, University of California,
# San Diego, 9500 Gilman Drive, Mail Code 0910, La Jolla, CA 92093-0910,
# Ph: (858) 534-5815, FAX: (858) 534-7345, E-MAIL:invent@ucsd.edu
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS''
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# @Copyright@
#

REDHAT.ROOT = $(CURDIR)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

PARMETIS_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-parmetis_$(COMPILERNAME)_$(MPINAME)
PARMETIS_INSTALL = /opt/parmetis/$(COMPILERNAME)/$(MPINAME)
PETSC_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-petsc_$(COMPILERNAME)_$(MPINAME)
PETSC_INSTALL = /opt/petsc/$(COMPILERNAME)/$(MPINAME)
SCALAPACK_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-scalapack_$(COMPILERNAME)_$(MPINAME)
SCALAPACK_INSTALL = /opt/scalapack/$(COMPILERNAME)/$(MPINAME)
SUPERLU_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-superlu_$(COMPILERNAME)_$(MPINAME)
SUPERLU_INSTALL = /opt/superlu/$(COMPILERNAME)/$(MPINAME)

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo LGPLv3 > $@

build: $(SRC_DIRS)
	# slepc includes dependent package paths in its installed files,
	# including its libraries, so we have to use bind mounts to avoid
	# having the installed s/w look for the cache dirs.
	$(call BIND_MOUNT, $(PARMETIS_INSTALL), $(PARMETIS_CACHE))
	$(call BIND_MOUNT, $(PETSC_INSTALL), $(PETSC_CACHE))
	$(call BIND_MOUNT, $(SCALAPACK_INSTALL), $(SCALAPACK_CACHE))
	$(call BIND_MOUNT, $(SUPERLU_INSTALL), $(SUPERLU_CACHE))
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MPI); \
	  cd $(SOURCE_DIR); \
	  export LD_LIBRARY_PATH=$(SUPERLU_CACHE):$${LD_LIBRARY_PATH}; \
	  export PETSC_DIR=$(PETSC_CACHE); \
	  unset PETSC_ARCH; \
	  ./configure --prefix=$(PKGROOT); \
	  make SLEPC_DIR=`pwd` PETSC_DIR=$(PETSC_CACHE) \
	)
	$(call BIND_UMOUNT, $(SUPERLU_INSTALL))
	$(call BIND_UMOUNT, $(SCALAPACK_INSTALL))
	$(call BIND_UMOUNT, $(PETSC_INSTALL))
	$(call BIND_UMOUNT, $(PARMETIS_INSTALL))
	@echo "::: Package $(NAME) build complete :::"

install::
	# Using a bind mount appears to be the only way to prevent the build
	# from incorporating $(ROOT) in binary files.
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	$(PKGROOT_BIND_MOUNT)
	( \
	  cd $(SOURCE_DIR); \
	  make SLEPC_DIR=`pwd` PETSC_DIR=$(PETSC_CACHE) install; \
	  cp -r src/eps/examples $(ROOT)/$(PKGROOT)/ \
	)
	$(PKGROOT_BIND_UMOUNT)
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE
