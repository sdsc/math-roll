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
  export ROLLCOMMENT=   
endif

ifeq ("$(ROLLNETWORK)", "eth")
  MPI= $(ROLLMPI)
else
  MPI= $(ROLLMPI)_$(ROLLNETWORK)
endif

ifeq ("${MKL_ROOT}", "")
   export MKL_ROOT=/opt/intel/Compiler/11.1/072/mkl
endif
MKLLINK=-L${MKL_ROOT}/lib/em64t -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread


MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPI); \
  fi; \
  export MPI_HOME=`which mpicxx | perl -pe 's!/bin/.*!!'`; \
  if test -z "$${MPI_HOME}"; then \
    export MPI_HOME=/opt/$(ROLLMPI); \
  fi; \
  echo Using MPI from $${MPI_HOME}; \
  export PATH=$${PATH}:$${MPI_HOME}/bin; \
  export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${MPI_HOME}/lib

PKGROOT = /opt/trilinos/$(ROLLCOMPILER)
SOURCE = trilinos-$(VERSION)
REDHAT.ROOT = $(PWD)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER); \
  fi


build:
	tar zxvf $(SOURCE).tar.gz
	( \
 	  $(COMPILERSETUP); \
          $(MPISETUP); \
           . /etc/profile.d/modules.sh; \
          module load cmake; \
          cd $(SOURCE); \
          mkdir build; \
          cd build; \
          cmake -D CMAKE_BUILD_TYPE:STRING=DEBUG -D CMAKE_Fortran_COMPILER:FILEPATH=$${MPI_HOME}/bin/mpif90 -D CMAKE_CXX_COMPILER:FILEPATH=$${MPI_HOME}/bin/mpicxx  -D CMAKE_C_COMPILER:FILEPATH=$${MPI_HOME}/bin/mpicc -D Trilinos_ENABLE_DEFAULT_PACKAGES:BOOL=ON -D Trilinos_ENABLE_Epetra:BOOL=ON -D Trilinos_ENABLE_Teuchos:BOOL=ON -D Trilinos_ENABLE_CTrilinos:BOOL=ON  -D Trilinos_ENABLE_ForTrilinos:BOOL=OFF -D Trilinos_ENABLE_TESTS:BOOL=ON -D TPL_BLAS_LIBRARIES:STRING="$(MKLLINK)" -D TPL_LAPACK_LIBRARIES:STRING="$(MKLLINK)" -D DART_TESTING_TIMEOUT:STRING=600 -D TPL_ENABLE_MPI:BOOL=ON -D MPI_BASE_DIR:PATH=${MPI_HOME} -D MPI_USE_COMPILER_WRAPPERS:BOOL=ON -D Trilinos_EXTRA_LINK_FLAGS:STRING="" -D MPI_EXEC_MAX_NUMPROCS:STRING=1024 -D TPL_MPI_INCLUDE_DIRS:INTERNAL=${MPI_HOME}/include -D TPL_MPI_LIBRARIES:INTERNAL=${MPI_HOME}/lib -D CMAKE_VERBOSE_MAKEFILE:BOOL=TRUE  -D Trilinos_VERBOSE_CONFIGURE:BOOL=TRUE  $(REDHAT.ROOT)src/trilinos/$(SOURCE);  \
          make \
        )

install::
	mkdir -p $(ROOT)/$(PKGROOT)
	( \
           cd $(SOURCE)/build; \
           make install \
	)

clean::
	rm -rf $(SOURCE)
