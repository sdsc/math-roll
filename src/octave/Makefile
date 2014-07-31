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
    module load $(FIRSTCOMPILER); \
  fi; \
  if test -n "$${MKL_ROOT}"; then \
    export MKLLIB=`find $${MKL_ROOT}/lib/* -maxdepth 0 | head -1`; \
    export LD_LIBRARY_PATH="$${MKLLIB}:$${LD_LIBRARY_PATH}"; \
    export LIBINCLUDE="-I$${MKL_ROOT}/include"; \
    export LIBLINK="-L$${MKLLIB} -lmkl_gf_ilp64 -lmkl_gnu_thread \
             -lmkl_core -ldl -lpthread -lm"; \
  fi; \
  if test "$(COMPILERNAME)" = "gnu"; then \
    gccdir=`which gcc | sed 's/\/gcc$$//'`; \
    if test "$${gccdir}" != "/usr/bin"; then \
      for F in `find $${gccdir}/.. -name include`; do \
        export LIBINCLUDE="$${LIBINCLUDE} -I$${F}"; \
      done; \
    fi; \
  fi

FFTWSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module=`module avail 2>&1 | grep -o -m1 "\<fftw\>"`; \
    if test "$${module}" != "fftw"; then \
      echo *** ERROR: fftw module not found; \
      exit 2; \
    fi; \
    module load fftw; \
  fi

HDF5SETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module=`module avail 2>&1 | grep -o -m1 "\<hdf5\>"`; \
    if test "$${module}" != "hdf5"; then \
      echo *** ERROR: hdf5 module not found; \
      exit 2; \
    fi; \
    module load hdf5; \
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
  fi

CC = gcc
CXX = g++
F77 = gfortran
COMPILER_FLAGS = -O2 -fopenmp -m64
ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    COMPILER_FLAGS += -mavx
  endif
endif

build: $(SRC_DIRS)
	( \
	  $(COMPILERSETUP); \
	  $(MPISETUP); \
	  $(FFTWSETUP); \
	  $(HDF5SETUP); \
	  export CC=$(CC); \
	  export CFLAGS="$(COMPILER_FLAGS) $${LIBINCLUDE}"; \
	  export CXX=$(CXX); \
	  export CXXFLAGS="$(COMPILER_FLAGS) $${LIBINCLUDE}"; \
	  export F77=$(F77); \
	  export FFLAGS="$(COMPILER_FLAGS) $${LIBINCLUDE}"; \
	  cd $(SOURCE_DIR); \
	  mkdir build; \
	  cd build; \
	  set; \
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
	mkdir -p -m 755 $(REDHAT.ROOT)/src/build-math-modules
	cat octave.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/octave!g;s!VERSION!$(VERSION)!g" \
	  > $(REDHAT.ROOT)/src/build-math-modules/$(NAME).module
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)

