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
ifndef ROLLNETWORK
  ROLLNETWORK = eth
endif
ifndef ROLLMPI
  ROLLMPI = openmpi
  export ROLLCOMMENT=   
endif

ifeq ("$(ROLLNETWORK)", "eth")
  MPI= $(ROLLMPI)
else
  MPI= $(ROLLMPI)_$(ROLLNETWORK)
endif


export MPITYPE=mpi
MPISETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(MPI); \
  fi; \
  export MPI_HOME=`which mpicxx | perl -pe 's!/bin/.*!!'`; \
  if test -z "$${MPI_HOME}"; then \
    export MPI_HOME=/opt/$(ROLLMPI); \
  fi; \
  echo Using MPI from $${MPI_HOME}; \
  export PATH=$${PATH}:$${MPI_HOME}/bin; \
  export LD_LIBRARY_PATH=$${LD_LIBRARY_PATH}:$${MPI_HOME}/lib; \
  if test $(ROLLMPI) = "mvapich" -o $(ROLLMPI) = "mvapich2" -o $(ROLLMPI) = "mpich" -o $(ROLLMPI) = "mpich2"; then \
      export MPITYPE=mpich; \
      export ROLLCOMMENT=\#; \
  fi

PKGROOT = /opt/scalapack/$(VERSION)/$(ROLLCOMPILER)
SOURCE = scalapack-$(VERSION)
REDHAT.ROOT = $(PWD)/../../
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk

export ROLL_FORTRAN=gfortran
export ROLL_CC=gcc
COMPILERSETUP = \
  if test -e /etc/profile.d/modules.sh; then \
    . /etc/profile.d/modules.sh; \
    module load $(ROLLCOMPILER); \
  fi; \
  if test $(ROLLCOMPILER) = "intel"; then \
      export ROLL_FORTRAN=ifort; \
      export ROLL_CC=icc; \
  elif test $(ROLLCOMPILER) = "pgi"; then \
      export ROLL_FORTRAN=pgf90; \
      export ROLL_CC=pgcc; \
  fi


build:
	tar zxvf $(SOURCE).tgz
	tar zvxf mpiblacs.tgz
	( \
 	  $(COMPILERSETUP); \
          $(MPISETUP); \
          cp patch-files/Bmake.inc BLACS/Bmake.inc; \
          cp patch-files/Makefile.root BLACS/SRC/MPI/Makefile; \
          cp patch-files/Makefile.testing BLACS/TESTING/Makefile; \
          perl -pi -e "s!ROLL_DIR!$(REDHAT.ROOT)/src/scalapack!; s!ROLL_MPI!$${MPI_HOME}!; s!ROLL_TYPE!$${MPITYPE}!;\
                   s!ROLL_FORTRAN!$${ROLL_FORTRAN}!; s!ROLL_CC!$${ROLL_CC}!"  BLACS/Bmake.inc; \
          perl -pi -e "s!ROLLCOMMENT!$${ROLLCOMMENT}!"  BLACS/SRC/MPI/Makefile; \
          perl -pi -e "s!ROLLCOMMENT!$${ROLLCOMMENT}!"  BLACS/TESTING/Makefile; \
          cd BLACS; \
          make all \
        )

install::
	mkdir -p $(ROOT)/$(PKGROOT)
	( \
	  cd $(SOURCE); \
	  cp scalapack.a $(ROOT)/$(PKGROOT)/lib/liblapack.a; \
	  cp eigsrc.a $(ROOT)/$(PKGROOT)/lib/libeigsrc.a; \
          cp linsrc.a $(ROOT)/$(PKGROOT)/lib/liblinsrc.a; \
          cp tmglib.a $(ROOT)/$(PKGROOT)/lib/libtmglib.a; \
	)

clean::
	rm -rf $(SOURCE) BLACS
