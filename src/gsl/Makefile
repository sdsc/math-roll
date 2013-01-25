
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

PKGROOT = /opt/gsl/$(ROLLCOMPILER)
SOURCE = gsl-$(VERSION)
REDHAT.ROOT = $(PWD)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    latestModule=`module avail 2>&1 | grep -o '$(ROLLCOMPILER)/[^ (]*' | sed 's/$(ROLLCOMPILER).//' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1`; \
    module load $(ROLLCOMPILER)/$${latestModule}; \
  fi

CC = gcc
COMPILE_FLAGS = -O2
ifeq ("$(ROLLCOMPILER)", "intel")
  CC = icc
  COMPILE_FLAGS = -O2 -fp-model precise
else ifeq ("$(ROLLCOMPILER)", "pgi")
  CC = pgcc
  COMPILE_FLAGS = -O1 -Mdaz 
else ifneq ("$(ROLLOPTS)", "$(subst avx,,$(ROLLOPTS))")
  COMPILE_FLAGS += -mavx
endif

build:
	tar zxvf $(SOURCE).tar.gz
	( \
          if test $(ROLLCOMPILER) = "pgi"; then \
              make clean; \
              exit; \
          fi; \
	  $(COMPILERSETUP); \
	  cd $(SOURCE); \
	  ./configure CC=$(CC) CFLAGS="$(COMPILE_FLAGS)" --prefix=$(PKGROOT); \
	  if test "$(ROLLCOMPILER)" = "pgi"; then \
	    perl -pi -e 's!.*#define  *HAVE_INLINE.*!/* #undef HAVE_INLINE */!' config.h; \
	  fi; \
	  make \
	)

install::
	mkdir -p -m 755 $(ROOT)/$(PKGROOT)
	mkdir -p -m 755 $(PKGROOT)
	mount --bind $(ROOT)/$(PKGROOT) $(PKGROOT)
	( \
          if test $(ROLLCOMPILER) = "pgi"; then \
              make clean; \
              rm -rf $(ROOT)/$(PKGROOT); \
              exit; \
          fi; \
	  $(COMPILERSETUP); \
	  cd $(SOURCE); \
	  make install prefix=$(PKGROOT); \
	  make check; \
	  mkdir -p -m 755 $(ROOT)/$(PKGROOT)/tests; \
	  for file in `cat ../patch-files/tests`; do \
	    cp -r $$file $(ROOT)/$(PKGROOT)/tests; \
	  done; \
	)
	umount $(PKGROOT)
	mkdir -p $(REDHAT.ROOT)/src/build-math-modules
	cat gsl.module | perl -pi -e "s!MODULEROOT!/opt/modulefiles/applications/.$(ROLLCOMPILER)/gsl!g;s!VERSION!$(VERSION)!g;s!ROLLCOMPILER!$(ROLLCOMPILER)!g" \
          > $(REDHAT.ROOT)/src/build-math-modules/$(NAME).module

clean::
	rm -rf $(SOURCE)
