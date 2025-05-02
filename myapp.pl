#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use MyApp;

$ENV{HYPNOTOAD_FOREGROUND} = 1;

MyApp->new->start;
1;