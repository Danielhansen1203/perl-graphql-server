#!/usr/bin/env perl
use strict;
use warnings;
use lib 'lib';
use MyApp;

$ENV{HYPNOTOAD_FOREGROUND} = 1;
$ENV{MOJO_LISTEN} = 'http://*:3000';

MyApp->new->start;