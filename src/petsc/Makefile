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
ifeq ("$(COMPILERNAME)", "intel")
  CC = icc
else ifeq ("$(COMPILERNAME)", "pgi")
  CC = pgcc
endif

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

PETSC_CACHE = $(REDHAT.ROOT)/src/build-petsc_$(COMPILERNAME)_$(ROLLMPI)
PARMETIS_CACHE = $(REDHAT.ROOT)/src/build-parmetis_$(COMPILERNAME)_$(ROLLMPI)
SUPERLU_CACHE = $(REDHAT.ROOT)/src/build-superlu_$(COMPILERNAME)_$(ROLLMPI)
SCALAPACK_CACHE = $(REDHAT.ROOT)/src/build-scalapack_$(COMPILERNAME)_$(ROLLMPI)

build: $(SRC_DIRS)
	( \
	  $(COMPILERSETUP); \
	  $(MKLSETUP); \
	  $(MPISETUP); \
	  cd $(SOURCE_DIR); \
	  MKLLINK="-Wl,--start-group $${MKLLIB}/libmkl_intel_lp64.a \
	           $${MKLLIB}/libmkl_sequential.a $${MKLLIB}/libmkl_core.a \
	           -Wl,--end-group -lpthread -lm"; \
	  export PETSC_DIR=`pwd`; \
	  export PETSC_ARCH=$(COMPILERNAME)-$(ROLLMPI); \
	  ./configure --prefix=$(PKGROOT) \
	    --with-mpi=1 \
	    --download-pastix=1 --download-ptscotch \
	    --with-blas-lib="$${MKLLINK}" --with-lapack-lib="$${MKLLINK}" \
	    --with-superlu_dist-include=$(SUPERLU_CACHE)/include \
	    --with-superlu_dist-lib="-L$(SUPERLU_CACHE)/lib -lsuperlu" \
	    --with-parmetis-dir=$(PARMETIS_CACHE) \
	    --with-metis-dir=$(PARMETIS_CACHE) \
	    --with-mpi-dir=$${MPIHOME} \
	    --with-scalapack-dir=$(SCALAPACK_CACHE) \
	    --download-mumps=yes \
	    --download-blacs=yes \
	    --download-fblaslapack=yes \
	    --with-pic=1 \
	    --with-shared-libraries=1; \
	    make all \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	# Using a bind mount appears to be the only way to prevent the build
	# from incorporating $(ROOT) in binary files.
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	-mkdir -p -m 755 $(PKGROOT)
	mount --bind $(ROOT)/$(PKGROOT) $(PKGROOT)
	( \
	  cd $(SOURCE_DIR); \
	  export PETSC_DIR=`pwd`; \
	  make BOPT=g shared; \
	  make install; \
	  cp -r src/snes/examples $(ROOT)/$(PKGROOT)/ \
	)
	umount $(PKGROOT)
	-rmdir -p $(PKGROOT)
	# Get rid of configure.log files that contain build dir path
	rm `find $(ROOT)/$(PKGROOT) -name configure.log`
	mkdir -p $(PETSC_CACHE)
	cp -r $(ROOT)/$(PKGROOT)/* $(PETSC_CACHE)
	# Fix paths in copy--slepc config checks for mismatch
	perl -pi -e "s#$(PKGROOT)#$(PETSC_CACHE)#g" \
	  `find $(PETSC_CACHE) -type f -exec grep -Il . {} ';'`
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR)
