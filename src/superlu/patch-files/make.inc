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
#		    September 1, 2011  version 3.0
#		    May 20, 2012       version 3.1
#
############################################################################
#
#  The machine (platform) identifier to append to the library names
#
PLAT		= _

#
#  The name of the libraries to be created/linked to
#
DSuperLUroot 	= ROLL_INSTALL
DSUPERLULIB   	= $(DSuperLUroot)/lib/libsuperlu_dist_3.1.a



BLASDEF	     	=  -DUSE_VENDOR_BLAS
BLASLIB	        = -Wl,--start-group  MKLROOT/lib/intel64/libmkl_intel_lp64.a MKLROOT/lib/intel64/libmkl_sequential.a MKLROOT/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm
METISLIB   	= -LROLL_PARMETIS -lmetis
PARMETISLIB   	= -LROLL_PARMETIS -lparmetis

# Define the required Fortran libraries, if you use C compiler to link
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
CC           	= mpicc
# CFLAGS should be set to be the C flags that include optimization
CFLAGS          =  -fPIC
#
# NOOPTS should be set to be the C flags that turn off any optimization
NOOPTS		= -O0 -fPIC
############################################################################
# FORTRAN compiler setup
FORTRAN         = mpif90
F90FLAGS	=  -fPIC
############################################################################
LOADER	        = $(CC)
LOADOPTS	= 
############################################################################
#  C preprocessor defs for compilation (-DNoChange, -DAdd_, or -DUpCase)
#
#  Need follow the convention of how C calls a Fortran routine.
#
CDEFS        = -DAdd_
