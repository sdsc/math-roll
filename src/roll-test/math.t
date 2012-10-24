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
    $output = `/bin/bash $TESTFILE.sh`;
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
    $output = `/bin/bash $TESTFILE.sh|grep -c -i fail`;
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
  $output = `/bin/bash $TESTFILE.sh`;
  like($output, qr/ans = -1\.0000e\+00/, 'simple octave test');
}

# parmetis
$packageHome = '/opt/parmetis';
SKIP: {
  skip 'parmetis not installed', 1 if ! -d $packageHome;
  fail('Need to write parmetis test');
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
$packageHome = '/opt/sprng';
SKIP: {
  skip 'sprng not installed', 1 if ! -d $packageHome;
  fail('Need to write sprng test');
}

# superlu
$packageHome = '/opt/superlu';
SKIP: {
  skip 'superlu not installed', 1 if ! -d $packageHome;
  fail('Need to write superlu test');
}

# trilinos
$packageHome = '/opt/trilinos';
SKIP: {
  skip 'trilinos not installed', 1 if ! -d $packageHome;
  fail('Need to write trilinos test');
}

`rm -f $TESTFILE*`;
