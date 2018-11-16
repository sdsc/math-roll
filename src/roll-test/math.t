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
  'eigen', 'gsl','lapack', 'parmetis', 'petsc', 'scalapack',
  'slepc', 'sprng', 'sundials', 'superlu'
);
my $output;
my @COMPILERS = split(/\s+/, 'ROLLCOMPILER');
my @MPIS = split(/\s+/, 'ROLLMPI');
my $TESTFILE = 'tmpmath';
my %CXX = ('gnu' => 'g++', 'intel' => 'icpc', 'pgi' => 'pgCC');

# math-install.xml
my @compilerNames = map {(split('/', $_))[0]} @COMPILERS;
foreach my $package(@packages) {
  if($appliance =~ /$installedOnAppliancesPattern/) {
    ok(-d "/opt/$package", "$package installed");
  } else {
    ok(! -d "/opt/$package", "$package not installed");
  }
}

SKIP: {

  foreach my $package(@packages) {
    skip "$package not installed", 3 if ! -d "/opt/$package";
    `/bin/ls /opt/modulefiles/applications/$package/[0-9]* 2>&1`;
    ok($? == 0, "$package module installed");
    `/bin/ls /opt/modulefiles/applications/$package/.version.[0-9]* 2>&1`;
    ok($? == 0, "$package version module installed");
    ok(-l "/opt/modulefiles/applications/$package/.version",
       "$package version module link created");
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
SKIP: {
  skip "gsl not installed", 1 if ! -d '/opt/gsl';
  my $versions = `/bin/ls /opt/gsl`;
  chomp($versions);
  foreach my $version (split(/\s+/, $versions)) {
    foreach my $compiler (@COMPILERS) {
      my $compilername = (split('/', $compiler))[0];
      $packageHome = "/opt/gsl/$version/$compilername";
      $testDir = "/opt/gsl/$version/$compilername/tests";
      SKIP: {
        skip "gsl/$version/$compilername not installed", 1 if ! -d $packageHome;
        skip "gsl/$version/$compilername tests not installed", 1 if ! -d $testDir;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
module load $compiler gsl/$version
mkdir $TESTFILE.gsl.$version.$compilername.dir
cd $TESTFILE.gsl.$version.$compilername.dir
/bin/cp -r \$GSLHOME/tests/* .
for test in *; do
if test -d \$test -a \$test != "poly"; then
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
          pass("$testcount/$testcount gsl/$version/$compilername tests passed");
        } else {
          fail(scalar(@successes) . "/$testcount gsl/$version/$compilername tests passed; " .
               scalar(@crashes) . ' (' . join(',', @crashes) . ') crashed; ' .
               scalar(@failures) . ' (' . join(',', @failures) . ') failed');
        }
      }
    }
  }
}

# lapack
# NOTE: as of v3.5.0, various lapack tests report "failed to pass threshold",
# regardless of the compiler used.  For our purposes, we chose one test that
# passes if the install has gone well.
foreach my $compiler (@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  $packageHome = "/opt/lapack/$compilername";
  $testDir = "$packageHome/runtests";
SKIP: {
    skip "lapack $compilername not installed", 1 if ! -d $packageHome;
    skip "lapack $compilername test not installed", 1 if ! -d $testDir;
    $output=`module load $compiler lapack; \$LAPACKHOME/runtests/xeigtstc < \$LAPACKHOME/runtests/cec.in`;
    like($output, qr/All tests.*passed/, "lapack/$compilername run");
  }
}

# parmetis
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    $packageHome = "/opt/parmetis/$compilername";
    SKIP: {
      skip "parmetis/$compilername not installed", 2 if ! -d $packageHome;
      open(OUT, ">$TESTFILE.sh");
      print OUT <<END;
#!/bin/bash
module load $compilername $mpi parmetis
output=`mpirun -n 2 \$PARMETISHOME/bin/ptest \$PARMETISHOME/Graphs/rotor.graph 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -n 2 \$PARMETISHOME/bin/ptest \$PARMETISHOME/Graphs/rotor.graph 2>&1`
fi
echo \$output
END
      close(OUT);
      $output = `/bin/bash $TESTFILE.sh 2>&1`;
      my @oks = $output =~ /OK:/g;
      ok(int(@oks) >= 80, "parmetis $compilername $mpi works");
    }
  }
  $output = `module load $compiler parmetis; echo \$PARMETISHOME 2>&1`;
  my $firstmpi = $MPIS[0];
  $firstmpi =~ s#/.*##;
  like($output, qr#/opt/parmetis/$compiler/$firstmpi#, 'parmetis modulefile defaults to first mpi');
}

# petsc
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    $packageHome = "/opt/petsc/$compilername";
    SKIP: {
      skip "petsc/$compilername not installed", 1 if ! -d $packageHome;
      open(OUT, ">$TESTFILE.sh");
      print OUT <<END;
#!/bin/bash
module load $compiler $mpi petsc
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp -r \$PETSCHOME/examples/* .
cd tutorials
cat makefile | sed 's/chkopts//' >temp
mv temp makefile
make PETSC_ARCH=arch-linux-c-debug PETSC_DIR=\$PETSCHOME ex1
ls -l ex1
output=`mpirun -n 1 ./ex1 -ksp_gmres_cgs_refinement_type refine_always -snes_monitor_short 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -n 1 ./ex1 -ksp_gmres_cgs_refinement_type refine_always -snes_monitor_short 2>&1`
fi
echo \$output
END
      close(OUT);
      $output = `/bin/bash $TESTFILE.sh 2>&1`;
      like($output, qr/Number of SNES iterations = 6/,
           "petsc/$compilername/$mpi tutorial run");
       `rm -rf $TESTFILE*`;
    }
  }
  $output = `module load $compiler petsc; echo \$PETSCHOME 2>&1`;
  my $firstmpi = $MPIS[0];
  $firstmpi =~ s#/.*##;
  like($output, qr#/opt/petsc/$compiler/$firstmpi#, 'petsc modulefile defaults to first mpi');
}

# scalapack
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    $packageHome = "/opt/scalapack/$compilername";
    SKIP: {
      skip "scalapack/$compilername not installed", 1 if ! -d $packageHome;
      open(OUT, ">$TESTFILE.sh");
      print OUT <<END;
#!/bin/bash
module load $compiler $mpi scalapack
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp -r \$SCALAPACKHOME/TESTING/* .
mpirun -np 4 ./xztrd
output=`mpirun -np 4 ./xztrd 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -np 4 ./xztrd 2>&1`
fi
echo \$output
END
      close(OUT);
      $output = `/bin/bash $TESTFILE.sh 2>&1`;
      like($output, qr/134 tests.*passed/,
      "scalapack/$compilername/$mpi example run");
      `rm -rf $TESTFILE*`;
    }
  }
  $output = `module load $compiler scalapack; echo \$SCALAPACKHOME 2>&1`;
  my $firstmpi = $MPIS[0];
  $firstmpi =~ s#/.*##;
  like($output, qr#/opt/scalapack/$compiler/$firstmpi#, 'scalapack modulefile defaults to first mpi');
}

# slepc
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    $packageHome = "/opt/slepc/$compilername";
    SKIP: {
      skip "slepc/$compilername not installed", 1 if ! -d $packageHome;
      open(OUT, ">$TESTFILE.sh");
      print OUT <<END;
#!/bin/bash
module load $compiler $mpi slepc
mkdir $TESTFILE.dir
cd $TESTFILE.dir
cp -r \$SLEPCHOME/examples/* .
cd tests
unset PETSC_ARCH
make SLEPC_DIR=/opt/slepc/$compilername/$mpi PETSC_DIR=/opt/petsc/$compilername/$mpi  test10
output=`mpirun -np 2 ./test10 -eps_nev 4 -eps_ncv 14 -m 11 -eps_largest_magnitude -eps_terse 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
    output=`mpirun --allow-run-as-root -np 2 ./test10 -eps_nev 4 -eps_ncv 14 -m 11 -eps_largest_magnitude -eps_terse 2>&1`
fi
echo \$output
END
      close(OUT);
      $output = `/bin/bash $TESTFILE.sh 2>&1`;
      like($output, qr/7.82110, 7.58462, 7.53702, 7.30054/,
           "slepc/$compilername/$mpi works");
      `rm -rf $TESTFILE*`;
    }
  }
  $output = `module load $compiler slepc; echo \$SLEPCHOME 2>&1`;
  my $firstmpi = $MPIS[0];
  $firstmpi =~ s#/.*##;
  like($output, qr#/opt/slepc/$compiler/$firstmpi#, 'slepc modulefile defaults to first mpi');
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
    $packageHome = "/opt/sprng/$compilername";
    SKIP: {
      skip "sprng/$compilername not installed", 2 if ! -d $packageHome;
      open(OUT, ">$TESTFILE.sh");
      print OUT <<END;
#!/bin/bash
module load $compiler $mpi sprng
mpicc -I \$SPRNGHOME/include -o $TESTFILE.sprng.exe $TESTFILE.sprng.c -L\$SPRNGHOME/lib -lsprng -L\$GMPHOME/lib -lgmp
ls -l *.exe
output=`mpirun -n 1 ./$TESTFILE.sprng.exe 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -n 1 ./$TESTFILE.sprng.exe 2>&1`
fi
echo \$output
END
      close(OUT);
      $output = `/bin/bash $TESTFILE.sh 2>&1`;
      like($output, qr/$TESTFILE.sprng.exe/,
           "sprng/$compilername/$mpi compilation");
      ok($? == 0, "sprng/$compilername/$mpi test run");
    }
  }
  $output = `module load $compiler sprng; echo \$SPRNGHOME 2>&1`;
  my $firstmpi = $MPIS[0];
  $firstmpi =~ s#/.*##;
  like($output, qr#/opt/sprng/$compiler/$firstmpi#, 'sprng modulefile defaults to first mpi');
}

# sundials
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    $packageHome = "/opt/sundials/$compilername";
    SKIP: {
      skip "sundials/$compilername not installed", 2 if ! -d $packageHome;
      open(OUT, ">$TESTFILE.sh");
      print OUT <<END;
#!/bin/bash
module load $compiler $mpi sundials
if [ ! -e fcvDiag_kry_p.f ]; then
cp $packageHome/$mpi/examples/cvode/fcmix_parallel/fcvDiag_kry_p.f .
EOF
fi
mpif77 -o $TESTFILE.sundials.exe  fcvDiag_kry_p.f  -L$packageHome/$mpi/lib -lsundials_fcvode -lsundials_cvode -lsundials_fnvecparallel -lsundials_nvecparallel
ls -l *.exe
output=`mpirun -n 4 ./$TESTFILE.sundials.exe 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -n 4 ./$TESTFILE.sundials.exe 2>&1`
fi
echo \$output
END
      close(OUT);
      $output = `/bin/bash $TESTFILE.sh 2>&1`;
      like($output, qr/$TESTFILE.sundials.exe/,
           "Sundials/$compilername/$mpi compilation");
      like($output, qr/number of conv. failures.. nonlinear = 0 linear = 0/, "Sundials/$compilername/$mpi run");
    }
  }
  $output = `module load $compiler sundials; echo \$SUNDIALSHOME 2>&1`;
  my $firstmpi = $MPIS[0];
  $firstmpi =~ s#/.*##;
  like($output, qr#/opt/sundials/$compiler/$firstmpi#, 'sundials modulefile defaults to first mpi');
}

# superlu
foreach my $compiler(@COMPILERS) {
  my $compilername = (split('/', $compiler))[0];
  foreach my $mpi(@MPIS) {
    $packageHome = "/opt/superlu/$compilername";
    SKIP: {
      skip "superlu/$compilername not installed", 1 if ! -d $packageHome;
      open(OUT, ">$TESTFILE.sh");
      print OUT <<END;
#!/bin/bash
module load $compiler $mpi superlu
output=`mpirun -n 1 \$SUPERLUHOME/EXAMPLE/pddrive \$SUPERLUHOME/EXAMPLE/g20.rua 2>&1`
if [[ "\$output" =~ "run-as-root" ]]; then
  output=`mpirun --allow-run-as-root -n 1 \$SUPERLUHOME/EXAMPLE/pddrive \$SUPERLUHOME/EXAMPLE/g20.rua 2>&1`
fi
echo \$output
END
      close(OUT);
      $output = `/bin/bash $TESTFILE.sh 2>&1`;
      like($output, qr/Sum-of-all/,
           "Superlu/$compilername/$mpi test run");
    }
  }
  $output = `module load $compiler superlu; echo \$SUPERLUHOME 2>&1`;
  my $firstmpi = $MPIS[0];
  $firstmpi =~ s#/.*##;
  like($output, qr#/opt/superlu/$compiler/$firstmpi#, 'superlu modulefile defaults to first mpi');
}

`rm -fr $TESTFILE*`;
