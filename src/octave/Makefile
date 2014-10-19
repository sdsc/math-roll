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
F77 = gfortran
COMPILER_FLAGS = -O2 -fopenmp -m64

ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(FIRSTCOMPILER)", "gnu")
    COMPILER_FLAGS += -mavx
  endif
endif

COMPILERSETUP =  \
  module load $(FIRSTCOMPILER) || true; \
  echo === Compiler and version ===; \
  $(CC) --version

FFTWSETUP = \
  module load fftw || true; \
  echo === FFTWHOME ===; \
  echo $${FFTWHOME}

HDF5SETUP = \
  module load hdf5 || true; \
  echo === HDF5HOME ===; \
  echo $${HDF5HOME}

MKLSETUP = \
  module load mkl || true; \
  echo === MKL_ROOT ===; \
  echo $${MKL_ROOT}; \
  export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`

MPISETUP = \
  module load $(FIRSTMPI) || true; \
  echo === MPIHOME ===; \
  echo $${MPIHOME}


build: $(SRC_DIRS)
	( \
	  $(COMPILERSETUP); \
	  $(MKLSETUP); \
	  $(MPISETUP); \
	  $(FFTWSETUP); \
	  $(HDF5SETUP); \
	  export LIBINCLUDE="-I$${MKL_ROOT}/include"; \
	  export LIBLINK="-Wl,-rpath,$${MKLLIB} -L$${MKLLIB} -lmkl_gf_ilp64 \
	                  -lmkl_gnu_thread -lmkl_core -ldl -lpthread -lm"; \
	  if test "$(COMPILERNAME)" = "gnu"; then \
	    gccdir=`which gcc | sed 's/\/gcc$$//'`; \
	    if test "$${gccdir}" != "/usr/bin"; then \
	      for F in `find $${gccdir}/.. -name include`; do \
	        export LIBINCLUDE="$${LIBINCLUDE} -I$${F}"; \
	      done; \
	    fi; \
	  fi; \
	  export CC=$(CC); \
	  export CFLAGS="$(COMPILER_FLAGS) $${LIBINCLUDE}"; \
	  export CXX=$(CXX); \
	  export CXXFLAGS="$(COMPILER_FLAGS) $${LIBINCLUDE}"; \
	  export F77=$(F77); \
	  export FFLAGS="$(COMPILER_FLAGS) $${LIBINCLUDE}"; \
	  cd $(SOURCE_DIR); \
	  mkdir build; \
	  cd build; \
	  ../configure --prefix=$(PKGROOT) \
	    --enable-64 --disable-docs \
	    --with-blas="$${LIBLINK}" --with-lapack="$${LIBLINK}" \
	    --with-fftw3=$${FFTWHOME} \
	    --with-hdf5=$${HDF5HOME} \
	)
	@echo "::: Package $(NAME) build complete :::"
	
install::
	# Using a bind mount appears to be the only way to prevent the build
	# from incorporating $(ROOT) in binary files.
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	-mkdir -p -m 755 $(PKGROOT)
	mount --bind $(ROOT)/$(PKGROOT) $(PKGROOT)
	( \
	  cd $(SOURCE_DIR)/build; \
	  $(MAKE) install; \
	)
	umount $(PKGROOT)
	-rmdir -p $(PKGROOT)
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)

