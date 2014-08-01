#!/usr/bin/perl -w
# math roll installation test.  Usage:
# math.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my @packages = (
  'eigen', 'gsl', 'lapack', 'octave', 'parmetis', 'petsc', 'scalapack',
  'slepc', 'sprng', 'sundials', 'superlu', 'trilinos'
);
my $output;
my @COMPILERS = split(/\s+/, 'ROLLCOMPILER');
my @MPIS = split(/\s+/, 'ROLLMPI');
my @NETWORKS = split(/\s+/, 'ROLLNETWORK');
my $SKIP = 'SKIP';
my $TESTFILE = 'tmpmath';
my %CXX = ('gnu' => 'g++', 'intel' => 'icpc', 'pgi' => 'pgCC');

# math-install.xml
my @compilerNames = map {(split('/', $_))[0]} @COMPILERS;
foreach my $package(@packages) {
  if($appliance =~ /$installedOnAppliancesPattern/ &&
     int(map {$SKIP =~ "${package}_$_"} @compilerNames) < int(@compilerNames)) {
    ok(-d "/opt/$package", "$package installed");
  } else {
    ok(! -d "/opt/$package", "$package not installed");
  }
}

SKIP: {

  skip 'modules not installed', 1 if ! -f '/etc/profile.d/modules.sh';

  foreach my $package(@packages) {
    skip "$package not installed", 3 if ! -d "/opt/$package";
    foreach my $compiler(@COMPILERS) {
      my $compilername = (split('/', $compiler))[0];
      next if $SKIP =~ "${package}_${compilername}";
      my $path = '/opt/modulefiles/applications' .
                 ($package =~ /eigen|octave/ ? '' : "/.$compilername");
      my $subpackage = $package =~ /eigen|octave/ ? $package : "$package/$compilername";
      `/bin/ls $path/$package/[0-9]* 2>&1`;
      ok($? == 0, "$subpackage module installed");
      `/bin/ls $path/$package/.version.[0-9]* 2>&1`;
      ok($? == 0, "$subpackage version module installed");
      ok(-l "$path/$package/.version",
         "$subpackage version module link created");
    }
  }

}


my ($packageHome, $testDir);

# eigen
open(OUT, ">$TESTFILE.cc");
print OUT <<END;
#include <iostream>
#include <Eigen/Dense>
using namespace Eigen;
int main()
{
Matrix2d mat;
mat << 1, 2,
3, 4;
Vector2d u(-1,1), v(2,0);
std::cout << "Here is mat*mat:\\n" << mat*mat << std::endl;
std::cout << "Here is mat*u:\\n" << mat*u << std::endl;
std::cout << "Here is u^T*mat:\\n" << u.transpose()*mat << std::endl;
std::cout << "Here is u^T*v:\\n" << u.transpose()*v << std::endl;
std::cout << "Here is u*v^T:\\n" << u*v.transpose() << std::endl;
std::cout << "Let's multiply mat by itself" << std::endl;
mat = mat*mat;
std::cout << "Now mat is mat:\\n" << mat << std::endl;
}
END
close(OUT);
$packageHome = "/opt/eigen";
SKIP: {
  skip "eigen not installed", 2 if ! -d $packageHome;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load eigen
$CXX{"gnu"} -o $TESTFILE.eigen.exe $TESTFILE.cc -I$packageHome/include/eigen3
ls -l *.exe
./$TESTFILE.eigen.exe
END
close(OUT);
  $output = `/bin/bash $TESTFILE.sh 2>&1`;
  like($output, qr/$TESTFILE.eigen.exe/, "eigen compilation");
  like($output, qr/15 22/, "eigen run");
}

# gsl
foreach my $compiler (@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  $packageHome = "/opt/gsl/$compilername";
  $testDir = "/opt/gsl/$compilername/tests";
  SKIP: {
    skip "gsl/$compilername not installed", 1 if ! -d $packageHome;
    skip "gsl/$compilername test not installed", 1 if ! -d $testDir;
    open(OUT, ">$TESTFILE.sh");
    print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler gsl
cd $packageHome/tests
for test in *; do
if test -d \$test; then
  cd $packageHome/tests
  echo === \$test: `\$test/test`
fi
done
END
    close(OUT);
    $output = `/bin/bash $TESTFILE.sh 2>&1`;
    my (@crashes, @failures, @successes);
    while ($output =~ s/=== (\w+): (.*)//) {
      my ($testname, $testout) = ($1, $2);
      if ($testout !~ /^Completed \[(\d+)\/(\d+)\]/) {
        push(@crashes, $testname);
      } elsif ($1 != $2) {
        push(@failures, $testname);
      } else {
        push(@successes, $testname);
      }
    }
    my $testcount = scalar(@crashes) + scalar(@failures) + scalar(@successes);
    if(scalar(@successes) == $testcount) {
      pass("$testcount/$testcount gsl/$compilername tests passed");
    } else {
      fail(scalar(@successes) . "/$testcount gsl/$compilername tests passed; " .
           scalar(@crashes) . ' (' . join(',', @crashes) . ') crashed; ' .
           scalar(@failures) . ' (' . join(',', @failures) . ') failed');
    }
  }
}


# lapack
foreach my $compiler (@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  $packageHome = "/opt/lapack/$compilername";
  $testDir = "$packageHome/runtests";
SKIP: {
  skip "lapack $compilername not installed", 1 if ! -d $packageHome;
  skip "lapack $compilername test not installed", 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler lapack
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp $testDir/* .
sh ./tests
cat *.out
END
    close(OUT);
    $output = `/bin/bash $TESTFILE.sh|grep -c -i fail 2>&1`;
    ok($output <= 31, "lapack $compilername tests");
    `rm -rf $TESTFILE*`;
  }
}

# octave
$packageHome = '/opt/octave';
SKIP: {
  skip 'octave not installed', 1 if ! -d $packageHome;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load intel octave
echo 'exp(i*pi)' | octave
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh 2>&1`;
  like($output, qr/ans = -1\.0000e\+00/, 'simple octave test');
}

# parmetis
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/parmetis/$compilername";
      SKIP: {
        skip "parmetis/$compilername not installed", 2 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compilername ${mpi}_${network} parmetis
mpirun -np 2 \$PARMETISHOME/bin/ptest \$PARMETISHOME/Graphs/rotor.graph
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh| grep -c OK: 2>&1`;
        ok($output >= 80, "parmetis $compilername $mpi $network works");

      }
    }
  }
}

# petsc
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/petsc/$compilername";
      SKIP: {
        skip "petsc/$compilername not installed", 1 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} petsc
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp -r \$PETSCHOME/examples/* .
cd tutorials
cat makefile|sed 's/chkopts//' >temp
mv temp makefile
make PETSC_ARCH=arch-linux-c-debug PETSC_DIR=\$PETSCHOME ex1
ls -l ex1
mpirun -np 1 ./ex1 -ksp_gmres_cgs_refinement_type refine_always -snes_monitor_short
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        like($output, qr/Number of SNES iterations = 6/,
             "petsc/$compilername/$mpi/$network tutorial run");
         `rm -rf $TESTFILE*`;
      }
    }
  }
}

# scalapack
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/scalapack/$compilername";
      SKIP: {
        skip "scalapack/$compilername not installed", 1 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} scalapack
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp \$SCALAPACKHOME/TESTING/* .
make test
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        like($output, qr/100% tests passed/,
        "scalapack/$compilername/$mpi/$network example run");
          `rm -rf $TESTFILE*`;
      }
    }
  }
}

# slepc
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/slepc/$compilername";
      SKIP: {
        skip "slepc/$compilername not installed", 1 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} slepc
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp -r \$SLEPCHOME/examples/* .
cd tests
unset PETSC_ARCH
make SLEPC_DIR=/opt/slepc/${compilername}/${mpi}/${network} PETSC_DIR=/opt/petsc/${compilername}/${mpi}/${network} testtest10
make SLEPC_DIR=/opt/slepc/${compilername}/${mpi}/${network} PETSC_DIR=/opt/petsc/${compilername}/${mpi}/${network} testtest7f
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh | grep -c successfully 2>&1`;
        ok($output >= 3, "slepc/$compilername/$mpi/$network works");
      }
    }
  }
}

        
# sprng
open(OUT, ">$TESTFILE.sprng.c");
print OUT <<END;
#include <stdio.h>
#include "sprng.h"
#define SEED 985456376
int main(int argc, char** argv) {
  int *stream = init_sprng(2, 0, 1, SEED, SPRNG_DEFAULT);
  print_sprng(stream);
  printf("%f\\n", sprng(stream));
  free_sprng(stream);
  return 0;
}
END
close(OUT);
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/sprng/$compilername";
      SKIP: {
        skip "sprng/$compilername not installed", 2 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} sprng
mpicc -I \$SPRNGHOME/include -o $TESTFILE.sprng.exe $TESTFILE.sprng.c -L\$SPRNGHOME/lib -lsprng -L/opt/gnu/gmp/lib -lgmp
ls -l *.exe
mpirun -np 1 ./$TESTFILE.sprng.exe
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        like($output, qr/$TESTFILE.sprng.exe/,
             "sprng/$compilername/$mpi/$network compilation");
        ok($? == 0, "sprng/$compilername/$mpi/$network test run");
      }
    }
  }
}

# sundials
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/sundials/$compilername";
      SKIP: {
        skip "sundials/$compilername not installed", 2 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} sundials
if [ ! -e fcvDiag_kry_p.f ]; then
cp $packageHome/${mpi}/${network}/examples/cvode/fcmix_parallel/fcvDiag_kry_p.f .
ex fcvDiag_kry_p.f <<EOF
:1,32s/INTEGER\\*4/INTEGER*8/
:w
:q
EOF
fi
mpif77 -o $TESTFILE.sundials.exe  fcvDiag_kry_p.f  -L$packageHome/$mpi/$network/lib -lsundials_fcvode -lsundials_cvode -lsundials_fnvecparallel -lsundials_nvecparallel
ls -l *.exe
mpirun -np 4 ./$TESTFILE.sundials.exe
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        like($output, qr/$TESTFILE.sundials.exe/,
             "Sundials/$compilername/$mpi/$network compilation");
        like($output, qr/0.9094/,
             "Sundials/$compilername/$mpi/$network run");
      }
    }
  }
}

# superlu
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/superlu/$compilername";
      SKIP: {
        skip "superlu/$compilername not installed", 1 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} superlu
mpirun -np 1 \$SUPERLUHOME/EXAMPLE/pddrive \$SUPERLUHOME/EXAMPLE/g20.rua
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        like($output, qr/nonzeros in L\+U     11694/,
             "Superlu/$compilername/$mpi/$network test run");
      }
    }
  }
}

# trilinos
open(OUT, ">$TESTFILE.tril.cxx");
print OUT <<END;
#include "Teuchos_Version.hpp"
using namespace Teuchos;
int main(int argc, char* argv[]) {
  std::cout << Teuchos::Teuchos_Version() << std::endl;
  return 0;
}
END
close(OUT);
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/trilinos/$compilername";
      SKIP: {
        skip "trilinos/$compilername not installed", 2 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} trilinos
export LD_LIBRARY_PATH=/opt/intel/composer_xe_2013.1.117/mkl/lib/intel64:\${LD_LIBRARY_PATH}
mpicxx -I\${TRILINOSHOME}/include -o $TESTFILE.tril.exe $TESTFILE.tril.cxx -L\${TRILINOSHOME}/lib -lteuchoscore
ls -l *.exe
./$TESTFILE.tril.exe
rm -f $TESTFILE.tril.exe
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        like($output, qr/$TESTFILE.tril.exe/,
             "Trilinos/$compilername/$mpi/$network compilation");
        like($output, qr/Teuchos in Trilinos [\d\.]+/,
             "Trilinos/$compilername/$mpi/$network run");
      }
    }
  }
}

`rm -fr $TESTFILE*`;
