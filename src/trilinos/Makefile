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

PKGROOT = /opt/trilinos/$(ROLLCOMPILER)/$(ROLLMPI)/$(ROLLNETWORK)
SOURCE = trilinos-$(VERSION)
REDHAT.ROOT = $(PWD)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load intel; \
    export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`; \
    export MKLLINK="-L$${MKLLIB} -lmkl_intel_lp64 -lmkl_sequential -lmkl_core \
                    -lpthread"; \
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
  export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${MPI_HOME}/lib; \
  export MPIRUN="$${MPI_HOME}/bin/mpirun"



build:
	tar zxvf $(SOURCE).tar.gz
	( \
          if test $(ROLLCOMPILER) = "pgi"; then \
              make clean; \
              rm -rf $(ROOT)/$(PKGROOT); \
              exit; \
          fi; \
  	  $(COMPILERSETUP); \
  	  $(MPISETUP); \
          module load cmake; \
  	  cd $(SOURCE); \
  	  mkdir build; \
  	  cd build; \
  	  cmake -DCMAKE_INSTALL_PREFIX:PATH=$(PKGROOT) \
  	        -DCMAKE_BUILD_TYPE:STRING=DEBUG \
  	        -DCMAKE_Fortran_COMPILER:FILEPATH=$${MPI_HOME}/bin/mpif90 \
  	        -DCMAKE_CXX_COMPILER:FILEPATH=$${MPI_HOME}/bin/mpicxx \
  	        -DCMAKE_C_COMPILER:FILEPATH=$${MPI_HOME}/bin/mpicc \
  	        -DTrilinos_ENABLE_DEFAULT_PACKAGES:BOOL=ON \
  	        -DTrilinos_ENABLE_Epetra:BOOL=ON \
  	        -DTrilinos_ENABLE_Teuchos:BOOL=ON \
  	        -DTrilinos_ENABLE_CTrilinos:BOOL=ON \
  	        -DTrilinos_ENABLE_ForTrilinos:BOOL=OFF \
  	        -DTrilinos_ENABLE_TESTS:BOOL=ON \
  	        -DTPL_BLAS_LIBRARIES:STRING="$${MKLLINK}" \
  	        -DTPL_LAPACK_LIBRARIES:STRING="$${MKLLINK}" \
  	        -DDART_TESTING_TIMEOUT:STRING=600 \
  	        -DTPL_ENABLE_MPI:BOOL=ON \
  	        -DMPI_BASE_DIR:PATH=${MPI_HOME} \
  	        -DMPI_USE_COMPILER_WRAPPERS:BOOL=ON \
  	        -DTrilinos_EXTRA_LINK_FLAGS:STRING="" \
  	        -DMPI_EXEC_MAX_NUMPROCS:STRING=8 \
                -DMPI_EXEC:FILEPATH="$${MPIRUN}" \
  	        -DTPL_MPI_INCLUDE_DIRS:INTERNAL="$${MPI_HOME}/include" \
  	        -DTPL_MPI_LIBRARIES:INTERNAL="$${MPI_HOME}/lib" \
  	        -DCMAKE_VERBOSE_MAKEFILE:BOOL=TRUE \
  	        -DTrilinos_VERBOSE_CONFIGURE:BOOL=TRUE \
  	        $(PWD)/$(SOURCE); \
  	  make \
       )

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	( \
          if test $(ROLLCOMPILER) = "pgi"; then \
              make clean; \
              rm -rf $(ROOT)/$(PKGROOT); \
              exit; \
          fi; \
	  cd $(SOURCE)/build; \
	  make prefix=$(ROOT)/$(PKGROOT) install \
	)
	cat trilinos.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/.$(ROLLCOMPILER)/trilinos!g;s!VERSION!$(VERSION)!g;s!ROLLCOMPILER!$(ROLLCOMPILER)!g" \
	  > $(REDHAT.ROOT)/src/build-math-modules/$(NAME).module

clean::
	rm -rf $(SOURCE)
