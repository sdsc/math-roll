#
# $Id$
#
# @Copyright@
#
#                               Rocks(r)
#                        www.rocksclusters.org
#                        version 7.0 (Manzanita)
#
# Copyright (c) 2000 - 2017 The Regents of the University of California.
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
#       "This product includes software developed by the Rocks(r)
#       Cluster Group at the San Diego Supercomputer Center at the
#       University of California, San Diego and its contributors."
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

REDHAT.ROOT = $(shell readlink -f $(CURDIR)/../..)
RPM.EXTRAS=%define __os_install_post /usr/lib/rpm/brp-compress

-include $(ROCKSROOT)/etc/Rules.mk
include Rules.mk
include $(SDSCDEVEL)/Pull.mk
include $(SDSCDEVEL)/Rules.mk

PETSC_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-petsc_$(COMPILERNAME)_$(MPINAME)
PARMETIS_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-parmetis_$(COMPILERNAME)_$(MPINAME)
PARMETIS_INSTALL = /opt/parmetis/$(COMPILERNAME)/$(MPINAME)
SUPERLU_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-superlu_$(COMPILERNAME)_$(MPINAME)
SUPERLU_INSTALL = /opt/superlu/$(COMPILERNAME)/$(MPINAME)
SCALAPACK_CACHE = $(REDHAT.ROOT)/cache/build-sdsc-scalapack_$(COMPILERNAME)_$(MPINAME)
SCALAPACK_INSTALL = /opt/scalapack/$(COMPILERNAME)/$(MPINAME)

$(NAME).spec: DESCRIPTION LICENSE

DESCRIPTION:
	$(MODULE_LOAD_CC); \
	( \
	  $(DESCRIBE_PKG); \
	  $(DESCRIBE_CC); \
	  $(DESCRIBE_MKL); \
	  $(DESCRIBE_MPI); \
          $(DESCRIBE_HDF5) \
	) > $@

LICENSE: $(SRC_DIRS)
	$(CHECK_LICENSE_FILES)
	echo University of Chicago > $@

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

LIBMP=
ifeq ("$(COMPILERNAME)","intel")
LIBMP=-liomp5
else ifeq ("$(COMPILERNAME)","gnu")
LIBMP=-lgomp
endif

build: $(SRC_PKGS)
	# petsc includes dependent package paths in its installed files,
	# including its libraries, so we have to use bind mounts to avoid
	# having the installed s/w look for the cache dirs.
	$(call BIND_MOUNT, $(PARMETIS_INSTALL), $(PARMETIS_CACHE))
	$(call BIND_MOUNT, $(SUPERLU_INSTALL), $(SUPERLU_CACHE))
	$(call BIND_MOUNT, $(SCALAPACK_INSTALL), $(SCALAPACK_CACHE))
	# Some files get installed during the configure step (?!?), so we have
	# to use a bind mount here to avoid polluting the build machine.
	( \
          if test "$(ROLLCOMPILER)" = "pgi"; then \
              tar xjf $(PASTIX_PKG); \
              patch $(PASTIX_DIR)/src/sopalin/src/sopalin_thread.h  patch-files/sopalin_thread.h.patch; \
              tar cjf $(PASTIX_PKG) $(PASTIX_DIR); \
          fi; \
	  $(MODULE_LOAD_CC); \
	  $(MODULE_LOAD_MKL); \
	  $(MODULE_LOAD_MPI); \
          $(MODULE_LOAD_HDF5); \
	  tar -xzf $(SOURCE_PKG); \
          if [[ "$(ROLLMPI)" == *"mvapich2"* ]]; then \
              patch $(SOURCE_DIR)/config/BuildSystem/config/base.py patch-files/base.py.patch; \
          fi; \
	  cd $(SOURCE_DIR); \
	  export PETSC_DIR=`pwd`; \
	  export PETSC_ARCH=$(COMPILERNAME)-$(MPINAME); \
	  ./configure CFLAGS="-fPIC $(AVX_FLAG)" FFLAGS="-fPIC $(AVX_FLAG)" CXXFLAGS="-fPIC $(AVX_FLAG)" --prefix=$(PKGROOT) \
	    --with-mpi=true \
	    --download-pastix=../$(PASTIX_PKG) \
	    --download-ptscotch=../$(SCOTCH_PKG) \
            --with-blas-lapack-dir=$${MKLHOME} \
	    --with-superlu_dist-include=$(SUPERLU_INSTALL)/include \
            --with-superlu_dist-lib="-L$(SUPERLU_INSTALL)/lib64 -lsuperlu_dist $(LIBMP)" \
	    --with-parmetis-dir=$(PARMETIS_INSTALL) \
	    --with-metis-dir=$(PARMETIS_INSTALL) \
	    --with-mpi-dir=$${MPIHOME} \
	    --with-scalapack-dir=$(SCALAPACK_INSTALL) \
	    --download-mumps=../$(MUMPS_PKG) \
	    --with-pic=true \
	    --with-shared-libraries=1 \
            --with-hdf5=true \
            --with-hdf5-dir=$${HDF5HOME} \
            --with-debugging=false; \
	  make -j 16 all; \
	)
	$(call BIND_UMOUNT, $(SCALAPACK_INSTALL))
	$(call BIND_UMOUNT, $(SUPERLU_INSTALL))
	$(call BIND_UMOUNT, $(PARMETIS_INSTALL))
	@echo "::: Package $(NAME) build complete :::"

install::
	# Using a bind mount appears to be the only way to prevent the build
	# from incorporating $(ROOT) in binary files.
	mkdir -p -m 755 $(ROOT)/$(PKGROOT) || true
	$(PKGROOT_BIND_MOUNT)
	( \
	  cd $(SOURCE_DIR); \
	  export PETSC_DIR=`pwd`; \
	  make BOPT=g shared; \
	  make install; \
	  cp -r src/snes/examples $(PKGROOT)/ \
	)
	$(PKGROOT_BIND_UMOUNT)
	$(INSTALL_LICENSE_FILES)
	# Get rid of configure.log files that contain build dir path
	-rm `find $(ROOT)/$(PKGROOT) -name configure.log`
	# Cache install for use by slepc
	mkdir -p $(PETSC_CACHE)
	cp -r $(ROOT)/$(PKGROOT)/* $(PETSC_CACHE)
	cp $(SOURCE_DIR)/$(COMPILERNAME)-$(MPINAME)/externalpackages/$(PASTIX_DIR)/install/*.a $(PETSC_CACHE)/lib
	cp $(SOURCE_DIR)/$(COMPILERNAME)-$(MPINAME)/externalpackages/$(PASTIX_DIR)/install/*.a $(ROOT)$(PKGROOT)/lib
	cp $(SOURCE_DIR)/$(COMPILERNAME)-$(MPINAME)/externalpackages/$(MUMPS_DIR)/lib/*.a $(PETSC_CACHE)/lib
	cp $(SOURCE_DIR)/$(COMPILERNAME)-$(MPINAME)/externalpackages/$(MUMPS_DIR)/lib/*.a $(ROOT)/$(PKGROOT)/lib
	cp $(SOURCE_DIR)/$(COMPILERNAME)-$(MPINAME)/externalpackages/$(MUMPS_DIR)/PORD/lib/*.a $(PETSC_CACHE)/lib
	cp $(SOURCE_DIR)/$(COMPILERNAME)-$(MPINAME)/externalpackages/$(MUMPS_DIR)/PORD/lib/*.a $(ROOT)/$(PKGROOT)/lib
	cp $(SOURCE_DIR)/$(COMPILERNAME)-$(MPINAME)/externalpackages/$(SCOTCH_DIR)/lib/*.a $(PETSC_CACHE)/lib
	cp $(SOURCE_DIR)/$(COMPILERNAME)-$(MPINAME)/externalpackages/$(SCOTCH_DIR)/lib/*.a $(ROOT)/$(PKGROOT)/lib
	# Fix paths in copy--slepc config checks for mismatch
	perl -pi -e "s#$(PKGROOT)#$(PETSC_CACHE)#g" \
	  `find $(PETSC_CACHE) -type f -exec grep -Il . {} ';'`
	@echo "::: Package $(NAME) install complete :::"

clean::
	rm -rf $(SOURCE_DIR) $(PASTIX_PKG) DESCRIPTION LICENSE
