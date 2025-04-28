#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";

# Sæt app-navn
$ENV{MOJO_MODE} = 'production';
$ENV{MOJO_APP} = 'MyApp';
$ENV{MOJO_LISTEN} = 'http://*:3000';
$ENV{HYPNOTOAD_FOREGROUND} = 1;

# Kør hypnotoad server korrekt
exec 'hypnotoad', $FindBin::Bin . '/myapp.pl';
