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

CC = gcc
CXX = g++
ifeq ("$(COMPILERNAME)", "intel")
  CC = icc
  CXX = icpc
else ifeq ("$(COMPILERNAME)", "pgi")
  CC = pgcc
  CXX = pgCC
endif

CMAKESETUP = \
  module load cmake || true; \
  echo === cmake version ===; \
  cmake --version

COMPILERSETUP =  \
  module load $(ROLLCOMPILER) || true; \
  echo === Compiler and version ===; \
  $(CC) --version

MKLSETUP = \
  module load mkl || true; \
  echo === MKL_ROOT ===; \
  echo $${MKL_ROOT}; \
  export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`

MPISETUP = \
  module load $(ROLLMPI) || true; \
  echo === MPIHOME ===; \
  echo $${MPIHOME}

PYSETUP = \
  module load $(ROLLPY) || true; \
  echo === Python and version ===; \
  echo `which python; python --version`

SWIG_CACHE = $(REDHAT.ROOT)/cache/build-swig

build: $(SRC_DIRS)
	mkdir $(SOURCE_DIR)/build
	( \
	  $(COMPILERSETUP); \
	  $(CMAKESETUP); \
	  $(MKLSETUP); \
	  $(MPISETUP); \
	  $(PYSETUP); \
	  if test ! -e $(SWIG_CACHE); then \
	    cd $(SWIG_DIR); \
	    ./configure CC=$(CC) CXX=$(CXX) --prefix=$(SWIG_CACHE); \
	    $(MAKE) -j 16; \
	    $(MAKE) -j 16 install; \
	    cd ..; \
	  fi; \
	  cd $(SOURCE_DIR)/build; \
	  MKLLINK="-L$${MKLLIB} -lmkl_intel_lp64 -lmkl_sequential -lmkl_core \
	           -lpthread"; \
	  export PATH=$(SWIG_CACHE)/bin:$${PATH}; \
	  cmake -DCMAKE_INSTALL_PREFIX:PATH=$(PKGROOT) \
	        -DCMAKE_BUILD_TYPE:STRING=DEBUG \
	        -DCMAKE_Fortran_COMPILER:FILEPATH=$${MPIHOME}/bin/mpif90 \
	        -DCMAKE_CXX_COMPILER:FILEPATH=$${MPIHOME}/bin/mpicxx \
	        -DCMAKE_C_COMPILER:FILEPATH=$${MPIHOME}/bin/mpicc \
	        -DTrilinos_ENABLE_DEFAULT_PACKAGES:BOOL=ON \
	        -DTrilinos_ENABLE_Epetra:BOOL=ON \
	        -DTrilinos_ENABLE_Teuchos:BOOL=ON \
	        -DTrilinos_ENABLE_CTrilinos:BOOL=ON \
	        -DTrilinos_ENABLE_ForTrilinos:BOOL=OFF \
	        -DTrilinos_ENABLE_TESTS:BOOL=ON \
	        -DTrilinos_ENABLE_PyTrilinos:BOOL=ON \
	        -DTPL_BLAS_LIBRARIES:STRING="$${MKLLINK}" \
	        -DTPL_LAPACK_LIBRARIES:STRING="$${MKLLINK}" \
	        -DDART_TESTING_TIMEOUT:STRING=600 \
	        -DTPL_ENABLE_MPI:BOOL=ON \
	        -DMPI_BASE_DIR:PATH=${MPIHOME} \
	        -DMPI_USE_COMPILER_WRAPPERS:BOOL=ON \
	        -DTrilinos_EXTRA_LINK_FLAGS:STRING="" \
	        -DMPI_EXEC_MAX_NUMPROCS:STRING=8 \
	        -DMPI_EXEC:FILEPATH="$${MPIHOME}/bin/mpirun" \
	        -DTPL_MPI_INCLUDE_DIRS:INTERNAL="$${MPIHOME}/include" \
	        -DTPL_MPI_LIBRARIES:INTERNAL="$${MPIHOME}/lib" \
	        -DCMAKE_VERBOSE_MAKEFILE:BOOL=TRUE \
	        -DTrilinos_VERBOSE_CONFIGURE:BOOL=TRUE \
	        -DBUILD_SHARED_LIBS:BOOL=ON \
	        $(PWD)/$(SOURCE_DIR); \
	  $(MAKE) -j 16 \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	# Using a bind mount appears to be the only way to prevent the build
	# from incorporating $(ROOT) in binary files.
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	-mkdir -p -m 755 $(PKGROOT)
	mount --bind $(ROOT)/$(PKGROOT) $(PKGROOT)
	( \
	  $(PYSETUP); \
	  cd $(SOURCE_DIR)/build; \
	  make install \
	)
	umount $(PKGROOT)
	-rmdir -p $(PKGROOT)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SRC_DIRS) $(REDHAT.ROOT)/src/build-swig
