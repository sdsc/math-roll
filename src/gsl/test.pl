#!/usr/bin/perl -w
use Test::More qw(no_plan);
my $TESTFILE = 'tmpmath';
my $packageHome = '/opt/gsl/intel';
my $testDir = '/opt/gsl/intel/testruns';
SKIP: {
  skip 'gsl not installed', 1 if ! -d $packageHome;
  skip 'gsl test not installed', 1 if ! -d $testDir;
  open(OUT, ">$TESTFILE.sh");
  print OUT <<END;
#!/bin/bash
. /etc/profile.d/modules.sh
module load intel
cd $packageHome/testruns
tests=`ls`
for test in \$tests; do
if test -d \$test; then
\$test/test
fi
done
./test_gsl_histogram.sh
END
  close(OUT);
  $output = `/bin/bash $TESTFILE.sh`;
  ok($output =~ /^(?!.*(?:FAIL))/, 'gsl tests');
  print $output;
}

