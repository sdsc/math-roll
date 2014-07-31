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

REDHAT.ROOT = $(CURDIR)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include pull.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module=`module avail 2>&1 | grep -o -m1 "\<$(FIRSTCOMPILER)\>"`; \
    if test "$${module}" != "$(FIRSTCOMPILER)"; then \
      echo *** ERROR: Compiler module $(FIRSTCOMPILER) not found; \
      exit 2; \
    fi; \
    module=`module avail 2>&1 | grep -o -m1 "\<cmake\>"`; \
    if test "$${module}" != "cmake"; then \
      echo *** ERROR: cmake module not found; \
      exit 2; \
    fi; \
    module load cmake $(ROLLCOMPILER); \
  fi

ifeq ("$(ROLLNETWORK)", "eth")
  MPIMODULE = $(ROLLMPI)
else
  MPIMODULE = $(ROLLMPI)_$(ROLLNETWORK)
endif

MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module=`module avail 2>&1 | grep -o -m1 "\<$(MPIMODULE)\>"`; \
    if test "$${module}" != "$(MPIMODULE)"; then \
      echo *** ERROR: MPI module $(MPIMODULE) not found; \
      exit 2; \
    fi; \
    module load $(MPIMODULE); \
  fi; \
  export MPI_HOME=`which mpicxx | perl -pe 's!/bin/.*!!'`; \
  if test -z "$${MPI_HOME}"; then \
    export MPI_HOME=/opt/$(ROLLMPI); \
  fi; \
  echo Using MPI from $${MPI_HOME}; \
  export PATH=$${PATH}:$${MPI_HOME}/bin; \
  export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${MPI_HOME}/lib

PARMETIS_CACHE = $(REDHAT.ROOT)/src/build-$(NAME)

build: $(SRC_DIRS)
	patch $(SOURCE_DIR)/Makefile patch-files/Makefile.parmetis.patch
	patch $(SOURCE_DIR)/metis/Makefile patch-files/Makefile.metis.patch
	patch $(SOURCE_DIR)/CMakeLists.txt patch-files/CMakeLists.txt.patch
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE_DIR); \
	  export CFLAGS=-fPIC; \
	  export CXXFLAGS=-fPIC; \
	  $(MAKE) -j 16 prefix=$(ROOT)/$(PKGROOT) config; \
	)
	@echo "::: Package $(NAME) build complete :::"
	
install::
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE_DIR); \
	  export CFLAGS=-fPIC; \
	  export CXXFLAGS=-fPIC; \
	  $(MAKE) -j 16 install; \
	  cp metis/include/metis.h $(ROOT)/$(PKGROOT)/include; \
	  cp build/Linux-x86_64/libmetis/libmetis.a $(ROOT)/$(PKGROOT)/lib; \
	  cp -r Graphs $(ROOT)/$(PKGROOT) \
	)
	mkdir -p -m 755 $(PARMETIS_CACHE)
	cp -r $(ROOT)/$(PKGROOT)/* $(PARMETIS_CACHE)/
	mkdir -p -m 755 $(REDHAT.ROOT)/src/build-math-modules
	cat parmetis.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/.$(COMPILERNAME)/parmetis!g;s!VERSION!$(VERSION)!g;s!ROLLCOMPILER!$(COMPILERNAME)!g" \
	  > $(REDHAT.ROOT)/src/build-math-modules/$(NAME).module
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)

