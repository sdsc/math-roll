############################################################################
#
#  Program:         SuperLU_DIST
#
#  Module:          make.inc
#
#  Purpose:         Top-level Definitions
#
#  Creation date:   February 4, 1999   version alpha
#
#  Modified:	    September 1, 1999  version 1.0
#                   March 15, 2003     version 2.0
#		    November 1, 2007   version 2.1
#		    September 1, 2011   version 3.0
#
############################################################################
#
#  The machine (platform) identifier to append to the library names
#
PLAT		= _xe6
#SDSC
PLAT		= _

#
#  The name of the libraries to be created/linked to
#
DSuperLUroot 	= ${HOME}/Release_Codes/SuperLU_DIST_3.3
DSUPERLULIB   	= $(DSuperLUroot)/lib/libsuperlu_dist_3.3.a
#SDSC
DSuperLUroot 	= ROLL_INSTALL
#
BLASDEF	     	= -DUSE_VENDOR_BLAS
BLASLIB	        =
#SDSC
BLASLIB	        = ROLL_MKLLINK
#
## parmetis 4.x.x, 32-bit integer
METISLIB    	= -L${HOME}/Hopper/lib/parmetis-4.0.2/build/Linux-x86_64/libmetis -lmetis
PARMETISLIB  	= -L${HOME}/Hopper/lib/parmetis-4.0.2/build/Linux-x86_64/libparmetis -lparmetis
## parmetis 4.x.x, 64-bit integer
# METISLIB    	= -L${HOME}/Hopper/lib/parmetis-4.0.2-64bit/build/Linux-x86_64/libmetis -lmetis
# PARMETISLIB  	= -L${HOME}/Hopper/lib/parmetis-4.0.2-64bit/build/Linux-x86_64/libparmetis -lparmetis
#SDSC
METISLIB   	= -LROLL_PARMETIS/lib -lmetis
PARMETISLIB   	= -LROLL_PARMETIS/lib -lparmetis

# Define the required Fortran libraries, if you use C compiler to link
FLIBS	 	= -lpgf90 -lpgf90_rpm1
#SDSC
FLIBS	 	= 

# Define all the libraries
LIBS	     	= $(DSUPERLULIB) $(BLASLIB) $(PARMETISLIB) $(METISLIB) $(FLIBS)

#
#  The archiver and the flag(s) to use when building archive (library)
#  If your system has no ranlib, set RANLIB = echo.
#
ARCH         	= ar
ARCHFLAGS    	= cr
RANLIB       	= ranlib

############################################################################
# C compiler setup
CC           	= cc
#SDSC
CC           	= mpicc
# CFLAGS should be set to be the C flags that include optimization
CFLAGS          = -fast -Mipa=fast,safe \
		-DDEBUGlevel=0 -DPRNTlevel=1 -DPROFlevel=0 \
#		-D_LONGINT
#
# NOOPTS should be set to be the C flags that turn off any optimization
NOOPTS		= -O0
############################################################################
# FORTRAN compiler setup
FORTRAN         = ftn
F90FLAGS	= -fast -Mipa=fast,safe
#SDSC
FORTRAN         = mpif90
F90FLAGS	=  -fPIC
############################################################################
LOADER	        = $(CC)
LOADOPTS	= -fast
#SDSC
LOADOPTS	=
############################################################################
#  C preprocessor defs for compilation (-DNoChange, -DAdd_, or -DUpCase)
#
#  Need follow the convention of how C calls a Fortran routine.
#
CDEFS        = -DAdd_
