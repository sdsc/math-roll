# SDSC "math" roll

## Overview

This roll bundles a collection of Math packages: eigen, GSL, LAPACK, Octave, Parmetis,petsc, ScaLAPACK, slepc, SPRNG, sundials, superLU, and Trilinos.

For more information about the various packages included in the math roll please visit their official web pages:

- <a href="http://http://eigen.tuxfamily.org/" target="_blank">eigen</a> is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms.
- <a href="http://www.gnu.org/software/gsl/" target="_blank">GSL</a> is a numerical library for C and C++ programmers.
- <a href="http://www.netlib.org/lapack/" target="_blank">LAPACK</a> provides routines for solving systems of simultaneous linear equations, least-squares solutions of linear systems of equations, eigenvalue problems, and singular value problems.
- <a href="http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview" target="_blank">ParMETIS</a> is an MPI-based parallel library that implements a variety of algorithms for partitioning unstructured graphs, meshes, and for computing fill-reducing orderings of sparse matrices.
- <a href="http://www.mcs.anl.gov/petsc/" target="_blank">petsc</a>  is a suite of data structures and routines for the scalable (parallel) solution of scientific applications modeled by partial differential equations
- <a href="http://www.netlib.org/scalapack/" target="_blank">ScaLAPACK</a> is a library of high-performance linear algebra routines for parallel distributed memory machines.
- <a href="http://www.grycap.upv.es/slepc" target="_blank">slepc</a>  is a software library for the solution of large scale sparse eigenvalue problems on parallel computers
- <a href="http://computation.llnl.gov/casc/sundials/main.html" target="_blank">sundials</a>  solves nonlinear and diffential equations
- <a href="http://www.sprng.org" target="_blank">SPRNG</a> is a scalable package for parallel pseudo random number generation which will be easy to use on a variety of architectures, especially in large-scale parallel Monte Carlo applications.
- <a href="http://crd-legacy.lbl.gov/~xiaoye/SuperLU/" target="_blank">SuperLU</a> is a general purpose library for the direct solution of large, sparse, nonsymmetric systems of linear equations on high performance machines.


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate math source file(s) using a machine that does
have Internet access and copy them into the `src/<package>` directories on your
Rocks development machine.


## Dependencies

Intel MKL libraries.  If you're building with the Intel compiler or there is
an mkl modulefile present (the mkl-roll provides this), then the build process
will pick these up automatically.  Otherwise, you'll need to set the MKL_ROOT
environment variable to the library location.

GMP libraries.  If there is an gmp modulefile present (the gnucompiler-roll provides
this), then the build process will pick these up automatically.  Otherwise,
you'll need to set the GMPHOME environment variable to the library location.

cmake.  If there is an cmake modulefile present (the cmake-roll provides
this), then the build process will pick this up automatically.  Otherwise,
you'll need to add the appropriate directory to your PATH environment variable.

## Building

To build the math-roll, execute this on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make 2>&1 | tee build.log
```

A successful build will create the files `math-*.iso`.  If you built the
roll on a Rocks frontend, proceed to the installation step. If you built the
roll on a Rocks development appliance, you need to copy the roll to your Rocks
frontend before continuing with installation.

This roll source supports building with different compilers and for different
MPI flavors.  The `ROLLCOMPILER` and `ROLLMPI` make variables can be used to
specify the names of compiler and MPI modulefiles to use for building the
software, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2_ib 2>&1 | tee build.log
```

The build process recognizes "gnu", "intel" or "pgi" as the value for the
`ROLLCOMPILER` variable; any MPI modulefile name may be used as the value of
the `ROLLMPI` variable.  The default values are "gnu" and "rocks-openmpi".

For gnu compilers, the roll also supports a `ROLLOPTS` make variable value of
'avx', indicating that the target architecture supports AVX instructions.


## Installation

To install, execute these instructions on a Rocks frontend:

```shell
% rocks add roll *.iso
% rocks enable roll math
% cd /export/rocks/install
% rocks create distro
% rocks run roll math | bash
```

In addition to the software itself, the roll installs individual environment
module files for each tool in:

```shell
/opt/modulefiles/applications
```


## Testing

The math-roll includes a test script which can be run to verify proper
installation of the roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/math.t 
```
