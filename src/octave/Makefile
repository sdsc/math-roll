
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

PKGROOT = /opt/octave
SOURCE = octave-$(VERSION)
REDHAT.ROOT = $(PWD)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk

COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER); \
  fi; \

build:
	tar zxvf $(SOURCE).tar.gz
	( \
          trap " " EXIT; \
          export CPPFLAGS=-I/home/diag/opt/hdf5/1.8.6/gnu/include; \
          export F77=gfortran; \
          . /etc/profile.d/modules.sh; \
          module load intel; \
          cp patch-files/sighandlers.cc $(SOURCE)/src; \
          cd $(SOURCE); \
          mkdir build; \
          cd build; \
          ../configure --prefix=$(ROOT)/$(PKGROOT) --without-curl --enable-64 --enable-docs=no --with-blas="$${MKL_ROOT}/lib/em64t/libmkl_solver_ilp64.a -Wl,--start-group  $${MKL_ROOT}/lib/em64t/libmkl_gf_ilp64.a $${MKL_ROOT}/lib/em64t/libmkl_gnu_thread.a $${MKL_ROOT}/lib/em64t//libmkl_core.a -Wl,--end-group -fopenmp -lpthread" --with-lapack="$${MKL_ROOT}/lib/em64t/libmkl_solver_ilp64.a -Wl,--start-group  $${MKL_ROOT}/lib/em64t/libmkl_gf_ilp64.a $${MKL_ROOT}/lib/em64t/libmkl_gnu_thread.a $${MKL_ROOT}/lib/em64t//libmkl_core.a -Wl,--end-group -fopenmp -lpthread" --with-fftw3-libdir=/home/diag/opt/fftw/3.2.1/gnu/lib --with-fftw3-includedir=/home/diag/opt/fftw/3.2.1/gnu/include --with-hdf5-libdir=/home/diag/opt/hdf5/1.8.6/gnu/lib --with-hdf5-includedir=/home/diag/opt/hdf5/1.8.6/gnu/include; \
          make -i \
        )

install::
	mkdir -p $(ROOT)/$(PKGROOT)
	( \
           cd $(SOURCE)/build; \
           make -i install \
	)

clean::
	rm -rf $(SOURCE)
