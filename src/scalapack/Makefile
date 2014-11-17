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
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

CFLAGS = -O2 -fPIC
FFLAGS= -fimplicit-none -O2 -fPIC
ROLLCOMMENT =
ifeq ("$(COMPILERNAME)", "intel")
  CFLAGS = -O2 -fPIC -DOMPI_WANT_MPI_INTERFACE_WARNING=0
  FFLAGS = -O2 -fPIC -DOMPI_WANT_MPI_INTERFACE_WARNING=0
else ifeq ("$(COMPILERNAME)", "pgi")
  CFLAGS = -O2 -fPIC
  FFLAGS = -O2 -fPIC
  ROLLPGI = -pgf90libs
endif

LAPACK_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-lapack_$(COMPILERNAME)
SCALAPACK_CACHE = $(REDHAT.ROOT)/cache/build-$(NAME)

LICENSE_FILES = $(SOURCE_DIR)/LICENSE

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI) \
	) > $@

LICENSE: $(SRC_DIRS)
	if ! grep -qF "2011 The University of Colorado" $(LICENSE_FILES); then \
	  exit 2; \
	fi
	echo BSD > $@

build: $(SRC_DIRS)
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_CMAKE); \
	  $(MODULE_LOAD_MPI); \
	  cd $(SOURCE_DIR); \
	  mkdir build_shared; \
	  cd build_shared; \
	  cmake .. \
	    -DCMAKE_INSTALL_PREFIX=$(ROOT)/$(PKGROOT) -DMPI_C_COMPILER=mpicc \
	    -DMPI_Fortran_COMPILER=mpif90 \
	    -DCMAKE_C_COMPILER=$(CC) -DCMAKE_Fortran_COMPILER=$(FC) \
	    -DCMAKE_C_FLAGS="$(CFLAGS)" -DCMAKE_Fortran_FLAGS="$(FFLAGS)" \
	    -DBUILD_SHARED_LIBS=ON \
	    -DLAPACK_LIBRARIES=$(LAPACK_CACHE)/lib/liblapack.a \
	    -DBLAS_LIBRARIES=$(LAPACK_CACHE)/lib/libblas.a; \
	  make; \
	  cd ..; \
	  mkdir build_static; \
	  cd build_static; \
	  cmake .. \
	    -DCMAKE_INSTALL_PREFIX=$(ROOT)/$(PKGROOT) -DMPI_C_COMPILER=mpicc \
	    -DMPI_Fortran_COMPILER=mpif90 \
	    -DCMAKE_C_COMPILER=$(CC) -DCMAKE_Fortran_COMPILER=$(FC) \
	    -DCMAKE_C_FLAGS="$(CFLAGS)" -DCMAKE_Fortran_FLAGS="$(FFLAGS)" \
	    -DLAPACK_LIBRARIES=$(LAPACK_CACHE)/lib/liblapack.a \
	    -DBLAS_LIBRARIES=$(LAPACK_CACHE)/lib/libblas.a; \
	  make \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	( \
	  cd $(SOURCE_DIR)/build_shared; \
	  make install; \
	  cd ../build_static; \
	  make install; \
	  cp -r TESTING ../EXAMPLE $(ROOT)/$(PKGROOT)/ \
	)
	$(INSTALL_LICENSE_FILES)
	# Fix references to install dir in rpm text files
	perl -pi -e "s#$(ROOT)##g" \
	  `find $(ROOT)/$(PKGROOT)/ -type f -exec grep -Il . {} ';'`
	mkdir -p $(SCALAPACK_CACHE)
	/bin/cp -r $(ROOT)/$(PKGROOT)/* $(SCALAPACK_CACHE)/
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) BLACS DESCRIPTION LICENSE
