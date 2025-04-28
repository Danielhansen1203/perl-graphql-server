#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";

use Mojolicious::Commands;

# Start din app med Hypnotoad via perl
local $ENV{MOJO_APP} = 'MyApp';
local $ENV{HYPNOTOAD_FOREGROUND} = 1;
local $ENV{MOJO_LISTEN} = 'http://*:3000';

Mojolicious::Commands->start('hypnotoad');
