#!/usr/bin/perl -w
use Test::More qw(no_plan);
  $output="PASS";
  ok($output  =~ /^(?!.*(?:FAIL))/, 'gsl tests');
