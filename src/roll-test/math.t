#!/usr/bin/perl -w
# math roll installation test.  Usage:
# math.t [nodetype]
#   where nodetype is one of "Compute", "Dbnode", "Frontend" or "Login"
#   if not specified, the test assumes either Compute or Frontend

use Test::More qw(no_plan);

my $appliance = $#ARGV >= 0 ? $ARGV[0] :
                -d '/export/rocks/install' ? 'Frontend' : 'Compute';
my $installedOnAppliancesPattern = '.';
my @packages = ('gsl', 'lapack', 'octave', 'parmetis', 'petsc',
                'scalapack', 'sprng', 'superlu', 'trilinos');
my $output;
my @COMPILERS = split(/\s+/, 'ROLLCOMPILER');
my @MPIS = split(/\s+/, 'ROLLMPI');
my @NETWORKS = split(/\s+/, 'ROLLNETWORK');
my $TESTFILE = 'tmpmath';

# math-install.xml
foreach my $package(@packages) {
  if($appliance =~ /$installedOnAppliancesPattern/) {
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
      my $path = '/opt/modulefiles/applications' .
                 ($package eq 'octave' ? '' : "/.$compiler");
      my $subpackage = $package eq 'octave' ? $package : "$package/$compiler";
      `/bin/ls $path/$package/[0-9]* 2>&1`;
      ok($? == 0, "$subpackage module installed");
      `/bin/ls $path/$package/.version.[0-9]* 2>&1`;
      ok($? == 0, "$subpackage version module installed");
      ok(-l "$path/$package/.version",
         "$subpackage version module link created");
      last if $package eq 'octave';
    }
  }

}


my ($packageHome, $testDir);

# gsl
foreach my $c (@COMPILERS) {
  $packageHome = "/opt/gsl/$c";
  $testDir = "/opt/gsl/$c/tests";
  SKIP: {
    skip "gsl/$c not installed", 1 if ! -d $packageHome;
    skip "gsl/$c test not installed", 1 if ! -d $testDir;
    open(OUT, ">$TESTFILE.sh");
    print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $c gsl
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
      pass("$testcount/$testcount gsl/$c tests passed");
    } else {
      fail(scalar(@successes) . "/$testcount gsl/$c tests passed; " .
           scalar(@crashes) . ' (' . join(',', @crashes) . ') crashed; ' .
           scalar(@failures) . ' (' . join(',', @failures) . ') failed');
    }
  }
}


# lapack
foreach my $c (@COMPILERS) {
  $packageHome = "/opt/lapack/$c";
  $testDir = "$packageHome/runtests";
SKIP: {
  skip "lapack $c not installed", 1 if ! -d $packageHome;
  skip "lapack $c test not installed", 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $c lapack
cd $testDir
sh ./tests
END
    close(OUT);
    $output = `/bin/bash $TESTFILE.sh|grep -c -i fail 2>&1`;
    ok($output <= 19, "lapack $c tests");
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
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/parmetis/$compiler";
      SKIP: {
        skip "parmetis/$compiler not installed", 2 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} parmetis
mpirun -np 2 \$PARMETISHOME/bin/ptest \$PARMETISHOME/Graphs/rotor.graph
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        ok($? == 0, "parmetis/$compiler/$mpi/$network run");
        like($output, qr/Initial Load Imbalance: 1.2197/,
             "parmetis/$compiler/$mpi/$network run output");
      }
    }
  }
}

# petsc
$packageHome = '/opt/petsc';
SKIP: {
  skip 'petsc not installed', 1 if ! -d $packageHome;
  fail('Need to write petsc test');
}

# scalapack
$packageHome = '/opt/scalapack';
SKIP: {
  skip 'scalapack not installed', 1 if ! -d $packageHome;
  fail('Need to write scalapack test');
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
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/sprng/$compiler";
      SKIP: {
        skip "sprng/$compiler not installed", 2 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} sprng
mpicc -I -o $TESTFILE.sprng.exe \$SPRNGHOME/include $TESTFILE.sprng.c -L\$SPRNGHOME/lib -lsprng -lgmp
ls -l *.exe
mpirun -np 1 $TESTFILE.sprng.exe
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        like($output, qr/$TESTFILE.sprng.exe/,
             "sprng/$compiler/$mpi/$network compilation");
        ok($? == 0, "sprng/$compiler/$mpi/$network test run");
      }
    }
  }
}

# superlu
foreach my $compiler(@COMPILERS) {
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/superlu/$compiler";
      SKIP: {
        skip "superlu/$compiler not installed", 1 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} superlu
mpirun -np 1 \$SUPERLUHOME/EXAMPLE/pddrive \$SUPERLUHOME/EXAMPLE/g20.rua
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        like($output, qr/Sol  0.*=\s*1.332268e-15/,
             "Superlu/$compiler/$mpi/$network test run");
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
  foreach my $mpi(@MPIS) {
    foreach my $network(@NETWORKS) {
      $packageHome = "/opt/trilinos/$compiler";
      SKIP: {
        skip "trilinos/$compiler not installed", 2 if ! -d $packageHome;
        open(OUT, ">$TESTFILE.sh");
        print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load $compiler ${mpi}_${network} trilinos
mpicxx -I\${TRILINOSHOME}/include -o $TESTFILE.tril.exe $TESTFILE.tril.cxx -L\${TRILINOSHOME}/lib -lteuchos
ls -l *.exe
./$TESTFILE.tril.exe
rm -f $TESTFILE.tril.exe
END
        close(OUT);
        $output = `/bin/bash $TESTFILE.sh 2>&1`;
        like($output, qr/$TESTFILE.tril.exe/,
             "Trilinos/$compiler/$mpi/$network compilation");
        like($output, qr/Teuchos in Trilinos [\d\.]+/,
             "Trilinos/$compiler/$mpi/$network run");
      }
    }
  }
}

`rm -f $TESTFILE*`;
