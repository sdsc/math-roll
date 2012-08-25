# $Id$
#
# @Copyright@
#
# 				Rocks(tm)
# 		         www.rocksclusters.org
# 		        version 4.3 (Mars Hill)
#
# Copyright (c) 2000 - 2011 The Regents of the University of California.
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
# 	"This product includes software developed by the Rocks(tm)
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


ifndef ROLLCOMPILER
  ROLLCOMPILER = gnu
endif
ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif
ifndef ROLLMPI
  ROLLMPI = openmpi
endif

PKGROOT = /opt/petsc/$(ROLLCOMPILER)/$(ROLLMPI)/$(ROLLNETWORK)
SOURCE = petsc-$(VERSION)
REDHAT.ROOT = $(PWD)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load intel; \
    export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`; \
    export MKLLINK="$${MKLLIB}/libmkl_solver_lp64_sequential.a \
                    -Wl,--start-group \
                    $${MKLLIB}/libmkl_intel_lp64.a \
                    $${MKLLIB}/libmkl_sequential.a \
                    $${MKLLIB}/libmkl_core.a -Wl,--end-group -lpthread"; \
    module unload intel; \
    latestModule=`module avail 2>&1 | grep -o '$(ROLLCOMPILER)/[^ (]*' | sort -V | tail -1`; \
    module load $${latestModule}; \
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
  $(REDHAT.ROOT)/src/build-parmetis_$(ROLLCOMPILER)_$(ROLLNETWORK)_$(ROLLMPI)
SUPERLU_HOME = \
  $(REDHAT.ROOT)/src/build-superlu_$(ROLLCOMPILER)_$(ROLLNETWORK)_$(ROLLMPI)


build:
	mkdir -p $(PKGROOT)
	mkdir -p $(ROOT)/$(PKGROOT)
	tar zxvf $(SOURCE).tar.gz
	mount --bind $(ROOT)/$(PKGROOT) $(PKGROOT)
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE); \
          export PATH=/opt/valgrind/bin:$${PATH}; \
	  ./configure --prefix=$(PKGROOT) \
	    --with-fc=mpif90 --with-cc=mpicc -with-mpi=1 \
            --download-pastix=1 \
            --download-ptscotch \
	    --with-blas-lib="$${MKLLINK}" --with-lapack-lib="$${MKLLINK}" \
	    --with-superlu-dist=1 \
	    --with-superlu_dist-include=$(SUPERLU_HOME)/include \
	    --with-superlu_dist-lib=$(SUPERLU_HOME)/lib/libsuperlu.a \
	    --with-parmetis-dist=1 \
	    --with-parmetis-include=$(PARMETIS_HOME)/include \
	    --with-parmetis-lib="-L$(PARMETIS_HOME)/lib -lparmetis -lmetis"; \
	  make PETSC_DIR=$(PWD)/$(SOURCE) PETSC_ARCH=arch-linux2-c-debug all \
	)
	umount $(PKGROOT)

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	mkdir -p -m 755 $(PKGROOT)
	mkdir -p $(REDHAT.ROOT)/src/build-math-modules
	mount --bind $(ROOT)/$(PKGROOT) $(PKGROOT)
	( \
	  cd $(SOURCE); \
	  make install \
	)
	umount $(PKGROOT)
	cat petsc.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/.$(ROLLCOMPILER)/petsc!g;s!VERSION!$(VERSION)!g;s!ROLLCOMPILER!$(ROLLCOMPILER)!g" \
          > $(REDHAT.ROOT)/src/build-math-modules/$(NAME).module

clean::
	rm -rf $(SOURCE)
