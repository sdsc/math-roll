# $Id$
#
# @Copyright@
# 
# 				Rocks(r)
# 		         www.rocksclusters.org
# 		         version 5.6 (Emerald Boa)
# 		         version 6.1 (Emerald Boa)
# 
# Copyright (c) 2000 - 2013 The Regents of the University of California.
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
# 	"This product includes software developed by the Rocks(r)
# 	Cluster Group at the San Diego Supercomputer Center at the
# 	University of California, San Diego and its contributors."
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
# $Log$

ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif
ifndef ROLLMPI
  ROLLMPI = openmpi
endif

REDHAT.ROOT = $(CURDIR)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include pull.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load intel; \
    export MKL_HOME=$${MKL_ROOT}; \
    module unload intel; \
    latestModule=`module avail 2>&1 | grep -o '$(ROLLCOMPILER)/[^ (]*' | sed 's/$(ROLLCOMPILER).//' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1`; \
    module load $(ROLLCOMPILER)/$${latestModule}; \
  fi

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI)
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPIMODULE); \
  fi; \
  export MPI_HOME=`which mpicxx | perl -pe 's!/bin/.*!!'`; \
  if test -z "$${MPI_HOME}"; then \
    export MPI_HOME=/opt/$(ROLLMPI); \
  fi; \
  echo Using MPI from $${MPI_HOME}; \
  export PATH=$${PATH}:$${MPI_HOME}/bin; \
  export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${MPI_HOME}/lib

PARMETIS_HOME = \
  $(REDHAT.ROOT)/src/build-parmetis_$(ROLLCOMPILER)_$(ROLLMPI)_$(ROLLNETWORK)
PARMETIS_MOUNT = \
  /opt/parmetis/$(ROLLCOMPILER)/$(ROLLMPI)/$(ROLLNETWORK)

build: $(SRC_DIRS)
	cp patch-files/make.inc $(SOURCE_DIR)
	mkdir -p -m 755 $(PKGROOT)
	mkdir -p $(PARMETIS_MOUNT)
	mount --bind $(PARMETIS_HOME) $(PARMETIS_MOUNT)
	mount --bind $(PWD)/$(SOURCE_DIR) $(PKGROOT)
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  perl -pi -e "s!ROLL_INSTALL!$(PWD)/$(SOURCE_DIR)!" $(SOURCE_DIR)/make.inc; \
	  perl -pi -e "s!ROLL_PARMETIS!$(PARMETIS_MOUNT)/lib!" $(SOURCE_DIR)/make.inc; \
	  perl -pi -e "s!MKLROOT!$${MKL_HOME}!g" $(SOURCE_DIR)/make.inc; \
	  cd $(SOURCE_DIR); \
	  $(MAKE)  \
	)
	umount $(PARMETIS_MOUNT)
	umount $(PKGROOT)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/lib
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/include
	mkdir -p -m 755 $(PKGROOT)
	mkdir -p $(PARMETIS_MOUNT)
	mount --bind $(PARMETIS_HOME) $(PARMETIS_MOUNT)
	mount --bind $(PWD)/$(SOURCE_DIR) $(PKGROOT)
	( \
	  cd $(SOURCE_DIR); \
	  $(MAKE)  install; \
	  cp lib/*.a $(ROOT)/$(PKGROOT)/lib/libsuperlu.a; \
	  cp SRC/*.h $(ROOT)/$(PKGROOT)/include; \
	  cp CBLAS/*.h $(ROOT)/$(PKGROOT)/include ; \
          chmod 0644 $(ROOT)/$(PKGROOT)/include/*; \
	  cp -r EXAMPLE $(ROOT)/$(PKGROOT); \
	  chmod 0755 $(ROOT)/$(PKGROOT)/EXAMPLE; \
	  chmod 0644 $(ROOT)/$(PKGROOT)/EXAMPLE/* \
	)
	umount $(PARMETIS_MOUNT)
	umount $(PKGROOT)
	mkdir -p $(REDHAT.ROOT)/src/build-math-modules
	cat superlu.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/.$(ROLLCOMPILER)/superlu!g;s!VERSION!$(VERSION)!g;s!ROLLCOMPILER!$(ROLLCOMPILER)!g" \
          > $(REDHAT.ROOT)/src/build-math-modules/$(NAME).module
	mkdir $(REDHAT.ROOT)/src/build-$(NAME)
	/bin/cp -r $(ROOT)/$(PKGROOT)/* $(REDHAT.ROOT)/src/build-$(NAME)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)
