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

MPIDEF = -DSPRNG_MPI -DOMPI_WANT_MPI_INTERFACE_WARNING=0

LICENSE_FILES = sprng-README

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_GMP); \
	  $(DESCRIBE_MPI) \
	) > $@

LICENSE: $(SRC_DIRS)
	#if ! grep -q "GNU GENERAL PUBLIC LICENSE" $(SOURCE_DIR)/COPYING; then \
	#  exit 2; \
	#fi
	echo Creative Commons > $@

build: $(SRC_DIRS)
	cp patch-files/make.GENERIC $(SOURCE_DIR)/SRC/
	( \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_GMP); \
	  $(MODULE_LOAD_MPI); \
	  cd $(SOURCE_DIR); \
	  if test -n "$${GMPHOME}"; then \
	    export GMPLINK="-L$${GMPHOME}/lib -lgmp"; \
	  else \
	    export GMPLINK=""; \
	  fi; \
	  $(MAKE) PLAT=GENERIC MPIDEF="$(MPIDEF)" GMPLIB="$${GMPLINK}" \
	)
	@echo "::: Package $(NAME) build complete :::"

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/lib
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/include
	cp $(SOURCE_DIR)/lib/*.a $(ROOT)/$(PKGROOT)/lib
	cp $(SOURCE_DIR)/include/* $(ROOT)/$(PKGROOT)/include
	cp -r $(SOURCE_DIR)/EXAMPLES $(ROOT)/$(PKGROOT)/
	chmod 0755 $(ROOT)/$(PKGROOT)/EXAMPLES
	chmod 0644 $(ROOT)/$(PKGROOT)/EXAMPLES/*.[cCF]
	chmod 0644 $(ROOT)/$(PKGROOT)/include/*
	$(INSTALL_LICENSE_FILES)
	@echo "::: Package $(NAME) build complete :::"

clean::
	rm -rf $(SOURCE_DIR) DESCRIPTION LICENSE

