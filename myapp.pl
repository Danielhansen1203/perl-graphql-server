#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use MyApp;

print "Loading MyApp from: $INC{'MyApp.pm'}\n";

MyApp->new->start;
