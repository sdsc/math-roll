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

COPTS = -O2 -fPIC
FOPTS = -fimplicit-none -O2 -fPIC
ifeq ("$(COMPILERNAME)", "intel")
  COPTS = -fPIC -O2
  FOPTS = -fPIC -O2
else ifeq ("$(COMPILERNAME)", "pgi")
  COPTS = -fast -fPIC
  FOPTS = -fast -fPIC
endif

AVX_FLAG=
ifneq ("$(ROLLOPTS)", "$(subst avx2,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    COPTS += -mavx2
    FOPTS += -mavx2
  else ifeq ("$(COMPILERNAME)", "intel")
    COPTS += -xHOST -xcore-avx2
    FOPTS += -xHOST -xcore-avx2
  endif
else ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    COPTS += -mavx
    FOPTS += -mavx
  else ifeq ("$(COMPILERNAME)", "intel")
    COPTS += -xavx
    FOPTS += -xavx
  endif
endif

BLAS_LIBRARY=$(PWD)/BLAS

LAPACK_CACHE = $(REDHAT.ROOT)/cache/build-$(NAME)

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo BSD > $@

build: $(SRC_DIRS)
	patch -o $(SOURCE_DIR)/make.inc $(SOURCE_DIR)/make.inc.example patch-files/make.inc.example.patch
	patch BLAS/make.inc patch-files/make.inc.patch
	patch $(SOURCE_DIR)/SRC/zgetrf2.f patch-files/zgetrf2.f.patch
	patch $(SOURCE_DIR)/SRC/zggsvd3.f patch-files/zggsvd3.f.patch
	( \
	  perl -pi -e "s!ROLL_FORTRAN!$(FC) $(FOPTS)!" $(SOURCE_DIR)/make.inc; \
	  perl -pi -e "s!ROLL_CC!$(CC) $(COPTS)!" $(SOURCE_DIR)/make.inc; \
	  perl -pi -e "s!ROLL_FORTRAN!$(FC) $(FOPTS)!" $(SOURCE_DIR)/make.inc; \
	  perl -pi -e "s!BLAS_LIBRARY!$(BLAS_LIBRARY)!" $(SOURCE_DIR)/make.inc; \
	  perl -pi -e "s!ROLL_FORTRAN!$(FC) $(FOPTS)!" BLAS/make.inc; \
	  $(MODULE_LOAD_CC); \
	  cd BLAS; \
	  make; \
	  mkdir tmp; \
	  cd tmp; \
	  ar -x ../blas.a; \
	  $(FC) $(FOPTS) -fPIC -shared *.o -Wl,-soname,libblas.so -o libblas.so; \
	  cd ../../$(SOURCE_DIR); \
	  $(MAKE); \
	  mkdir tmp; \
	  cd tmp; \
	  ar -x ../liblapack.a; \
	  $(FC) $(FOPTS) -fPIC -shared *.o -Wl,-soname,liblapack.so -o liblapack.so; \
	  rm *.o; \
	  ar -x ../libtmglib.a; \
	  $(FC) $(FOPTS) -fPIC -shared *.o -Wl,-soname,libtmglib.so -o libtmglib.so; \
	)
	@echo "::: Package $(NAME) build complete :::"
	
install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/lib
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/include
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/runtests
	( \
	  cp BLAS/blas.a $(ROOT)/$(PKGROOT)/lib/libblas.a; \
	  cp BLAS/tmp/libblas.so $(ROOT)/$(PKGROOT)/lib; \
	  cd $(SOURCE_DIR); \
	  cp liblapack.a $(ROOT)/$(PKGROOT)/lib/liblapack.a; \
	  cp libtmglib.a $(ROOT)/$(PKGROOT)/lib/libtmglib.a; \
	  cp tmp/liblapack.so $(ROOT)/$(PKGROOT)/lib; \
	  cp tmp/libtmglib.so $(ROOT)/$(PKGROOT)/lib; \
	  if test -e TESTING/xeigtstd; then \
	    cp TESTING/x* TESTING/*.in \
	       $(ROOT)/$(PKGROOT)/runtests; \
	  fi \
	)
	$(INSTALL_LICENSE_FILES)
	mkdir -p -m 755 $(LAPACK_CACHE)
	/bin/cp -r $(ROOT)/$(PKGROOT)/* $(LAPACK_CACHE)/
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) BLAS DESCRIPTION LICENSE

