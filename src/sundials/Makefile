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

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	$(MODULE_LOAD_PYTHON); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MPI); \
          $(DESCRIBE_PYTHON) \
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
	tar zxvf $(SOURCE_DIR).tar.gz
	patch $(SOURCE_DIR)/src/kinsol/fcmix/fkinsol.c patch-files/fkinsol.c.patch
	patch $(SOURCE_DIR)/include/idas/idas.h patch-files/idas.h.patch
	patch $(SOURCE_DIR)/examples/idas/serial/idasRoberts_ASAi_dns.c patch-files/idasRoberts_ASAi_dns.c.patch
	patch $(SOURCE_DIR)/examples/idas/serial/idasHessian_ASA_FSA.c  patch-files/idasHessian_ASA_FSA.c.patch
	patch $(SOURCE_DIR)/examples/idas/serial/idasSlCrank_FSA_dns.c  patch-files/idasSlCrank_FSA_dns.c.patch
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MPI); \
          $(MODULE_LOAD_CMAKE); \
          $(MODULE_LOAD_PYTHON); \
	  cd $(SOURCE_DIR); \
          mkdir build; \
          cd build; \
          export CFLAGS=$(AVX_FLAG); \
          export FFLAGS=$(AVX_FLAG); \
          cmake -DCMAKE_INSTALL_PREFIX=$(ROOT)/$(PKGROOT) -DMPI_ENABLE=ON \
            -DCMAKE_C_COMPILER=$(CC) -DCMAKE_CXX_COMPILER=$(CXX)  \
            -DCMAKE_Fortran_COMPILER=$(FC) -DMPI_MPICC=`which mpicc` -DMPI_MPICXX=mpicxx \
            -DMPI_MPIF77=`which mpif77` -DMPI_MPIF90=`which mpif90` -DFCMIX_ENABLE=ON \
            -DF90_ENABLE=ON -DCXX_ENABLE=ON -DOPENMP_ENABLE=ON -DEXAMPLES_ENABLE=ON .. ; \
             make -j 16 \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MPI); \
          $(MODULE_LOAD_CMAKE); \
          $(MODULE_LOAD_PYTHON); \
	  cd $(SOURCE_DIR)/build; \
	  make install \
	)
	$(INSTALL_LICENSE_FILES)
	# Fix references to install dir in rpm text files
	perl -pi -e "s#$(ROOT)##g" \
	  `find $(ROOT)/$(PKGROOT)/ -type f -exec grep -Il . {} ';'`
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE

