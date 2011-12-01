#
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

PKGROOT = /opt/lapack/$(ROLLCOMPILER)
SOURCE = lapack-$(VERSION)
REDHAT.ROOT = $(PWD)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER); \
  fi

FC = gfortran -implicit-none
ifeq ("$(ROLLCOMPILER)", "intel")
  FC = ifort
else ifeq ("$(ROLLCOMPILER)", "pgi")
  FC = pgf90
endif

build:
	tar zxvf $(SOURCE).tgz
	cp patch-files/make.inc.lapack $(SOURCE)/make.inc
	perl -pi -e "s!ROLL_FORTRAN!$(FC)!" $(SOURCE)/make.inc
	tar zvxf blas.tgz
	cp patch-files/make.inc.blas BLAS/make.inc
	perl -pi -e "s!ROLL_FORTRAN!$(FC)!" BLAS/make.inc
	( \
	  $(COMPILERSETUP); \
	  cd BLAS; \
	  make; \
	  cd ../$(SOURCE); \
	  make \
	)

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/lib
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/include
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)/runtests
	( \
	  cp BLAS/blas.a $(ROOT)/$(PKGROOT)/lib/libblas.a; \
	  cd $(SOURCE); \
	  cp lapack.a $(ROOT)/$(PKGROOT)/lib/liblapack.a; \
	  cp tmglib.a $(ROOT)/$(PKGROOT)/lib/libtmglib.a; \
	  cp ../patch-files/tests TESTING/x* TESTING/*.in \
	     $(ROOT)/$(PKGROOT)/runtests \
	)
	mkdir -p $(REDHAT.ROOT)/src/build-$(NAME)
	/bin/cp -r $(ROOT)/$(PKGROOT)/* $(REDHAT.ROOT)/src/build-$(NAME)

clean::
	rm -rf $(SOURCE) BLAS
