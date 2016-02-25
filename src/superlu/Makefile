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

PARMETIS_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-parmetis_$(COMPILERNAME)_$(ROLLMPI)
SUPERLU_CACHE = $(REDHAT.ROOT)/cache/build-$(NAME)

CFLAGS = -fPIC -I$(PARMETIS_CACHE)/include
NOOPTS = -fPIC -O0 -I$(PARMETIS_CACHE)/include
ifneq ("$(COMPILERNAME)", "pgi")
  CFLAGS += -std=c99
  NOOPTS += -std=c99
endif

MKLLINK = -Wl,--start-group $${MKLLIB}/libmkl_intel_lp64.a $${MKLLIB}/libmkl_sequential.a $${MKLLIB}/libmkl_core.a -Wl,--end-group -lpthread -lm

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MKL); \
	  $(DESCRIBE_MPI) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo BSD > $@

AVX_FLAG=
ifneq ("$(ROLLOPTS)", "$(subst avx2,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    AVX_FLAG = -mavx2
  else ifeq ("$(COMPILERNAME)", "intel")
    AVX_FLAG = -xcore-avx2
  endif
else ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  ifeq ("$(COMPILERNAME)", "gnu")
    AVX_FLAG = -mavx
  else ifeq ("$(COMPILERNAME)", "intel")
    AVX_FLAG = -xavx
  endif
endif

build: $(SRC_DIRS)
	patch $(SOURCE_DIR)/make.inc patch-files/make.inc.patch
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MKL); \
	  export MKLLIB=`find $${MKLHOME}/lib/* -maxdepth 0 | head -1`; \
	  $(MODULE_LOAD_MPI); \
	  perl -pi -e "s!ROLL_INSTALL!$(PWD)/$(SOURCE_DIR)!" $(SOURCE_DIR)/make.inc; \
	  perl -pi -e "s!ROLL_PARMETIS!$(PARMETIS_CACHE)!" $(SOURCE_DIR)/make.inc; \
	  perl -pi -e "s!ROLL_MKLLINK!$(MKLLINK)!" $(SOURCE_DIR)/make.inc; \
	  cd $(SOURCE_DIR); \
          CFLAGS="$(CFLAGS) $(AVX_FLAG)"; \
	  $(MAKE) CFLAGS="$(CFLAGS)" NOOPTS="$(NOOPTS)" \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/lib
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/include
	( \
	  cd $(SOURCE_DIR); \
	  $(MAKE) prefix=$(ROOT)/$(PKGROOT) install; \
	  cp lib/*.a $(ROOT)/$(PKGROOT)/lib/libsuperlu.a; \
	  cp SRC/*.h $(ROOT)/$(PKGROOT)/include; \
	  cp CBLAS/*.h $(ROOT)/$(PKGROOT)/include ; \
	  chmod 0644 $(ROOT)/$(PKGROOT)/include/*; \
	  cp -r EXAMPLE $(ROOT)/$(PKGROOT); \
	  chmod go+rx $(ROOT)/$(PKGROOT)/EXAMPLE; \
	  chmod go+rX $(ROOT)/$(PKGROOT)/EXAMPLE/* \
	)
	$(INSTALL_LICENSE_FILES)
	mkdir $(SUPERLU_CACHE)
	/bin/cp -r $(ROOT)/$(PKGROOT)/* $(SUPERLU_CACHE)/
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE
