# SDSC "math" roll

## Overview

This roll bundles a collection of Math packages: eigen, GSL, LAPACK, Octave, Parmetis,petsc, ScaLAPACK, slepc, SPRNG, sundials, superLU, and Trilinos.

For more information about the various packages included in the math roll please visit their official web pages:

- <a href="http://http://eigen.tuxfamily.org/" target="_blank">eigen</a> is a C++ template library for linear algebra: matrices, vectors, numerical solvers, and related algorithms.
- <a href="http://www.gnu.org/software/gsl/" target="_blank">GSL</a> is a numerical library for C and C++ programmers.
- <a href="http://www.netlib.org/lapack/" target="_blank">LAPACK</a> provides routines for solving systems of simultaneous linear equations, least-squares solutions of linear systems of equations, eigenvalue problems, and singular value problems.
- <a href="http://www.gnu.org/software/octave/" target="_blank">Octave</a> is a high-level interpreted language, primarily intended for numerical computations. It provides capabilities for the numerical solution of linear and nonlinear problems, and for performing other numerical experiments.
- <a href="http://glaros.dtc.umn.edu/gkhome/metis/parmetis/overview" target="_blank">ParMETIS</a> is an MPI-based parallel library that implements a variety of algorithms for partitioning unstructured graphs, meshes, and for computing fill-reducing orderings of sparse matrices.
- <a href="http://www.mcs.anl.gov/petsc/" target="_blank">petsc</a>  is a suite of data structures and routines for the scalable (parallel) solution of scientific applications modeled by partial differential equations
- <a href="http://www.netlib.org/scalapack/" target="_blank">ScaLAPACK</a> is a library of high-performance linear algebra routines for parallel distributed memory machines.
- <a href="http://www.grycap.upv.es/slepc" target="_blank">slepc</a>  is a software library for the solution of large scale sparse eigenvalue problems on parallel computers
- <a href="http://computation.llnl.gov/casc/sundials/main.html" target="_blank">sundials</a>  solves nonlinear and diffential equations
- <a href="http://www.sprng.org" target="_blank">SPRNG</a> is a scalable package for parallel pseudo random number generation which will be easy to use on a variety of architectures, especially in large-scale parallel Monte Carlo applications.
- <a href="http://crd-legacy.lbl.gov/~xiaoye/SuperLU/" target="_blank">SuperLU</a> is a general purpose library for the direct solution of large, sparse, nonsymmetric systems of linear equations on high performance machines.
- <a href="http://trilinos.sandia.gov/citing.html" target="_blank">Trilinos</a> is an effort to develop algorithms and enabling technologies within an object-oriented software framework for the solution of large-scale, complex multi-physics engineering and scientific problems.


## Requirements

To build/install this roll you must have root access to a Rocks development
machine (e.g., a frontend or development appliance).

If your Rocks development machine does *not* have Internet access you must
download the appropriate math source file(s) using a machine that does
have Internet access and copy them into the `src/<package>` directories on your
Rocks development machine.


## Dependencies

Unknown at this time.


## Building

To build the math-roll, execute these instructions on a Rocks development
machine (e.g., a frontend or development appliance):

```shell
% make default 2>&1 | tee build.log
% grep "RPM build error" build.log
```

If nothing is returned from the grep command then the roll should have been
created as... `math-*.iso`. If you built the roll on a Rocks frontend then
proceed to the installation step. If you built the roll on a Rocks development
appliance you need to copy the roll to your Rocks frontend before continuing
with installation.

This roll source supports building with different compilers and for different
network fabrics and mpi flavors.  By default, it builds using the gnu compilers
for openmpi ethernet.  To build for a different configuration, use the
`ROLLCOMPILER`, `ROLLMPI` and `ROLLNETWORK` make variables, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mpich2 ROLLNETWORK=mx 
```

The build process currently supports one or more of the values "intel", "pgi",
and "gnu" for the `ROLLCOMPILER` variable, defaulting to "gnu".  It supports
`ROLLMPI` values "openmpi", "mpich2", and "mvapich2", defaulting to "openmpi".
It uses any `ROLLNETWORK` variable value(s) to load appropriate mpi modules,
assuming that there are modules named `$(ROLLMPI)_$(ROLLNETWORK)` available
(e.g., `openmpi_ib`, `mpich2_mx`, etc.).

If the `ROLLCOMPILER`, `ROLLNETWORK` and/or `ROLLMPI` variables are specified,
their values are incorporated into the names of the produced roll and rpms, e.g.,

```shell
make ROLLCOMPILER=intel ROLLMPI=mvapich2 ROLLNETWORK=ib
```
produces a roll with a name that begins "`math_intel_mvapich2_ib`"; it
contains and installs similarly-named rpms.

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
installation of the math-roll documentation, binaries and module files. To
run the test scripts execute the following command(s):

```shell
% /root/rolltests/math.t 
ok 1 - math is installed
ok 2 - math test run
ok 3 - math module installed
ok 4 - math version module installed
ok 5 - math version module link created
1..5
```
