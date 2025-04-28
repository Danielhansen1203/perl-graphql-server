#!/usr/bin/env perl
use strict;
use warnings;
use Mojolicious::Lite;
use Mojolicious::Plugin::GraphQL;
use GraphQL::Schema;
use GraphQL::Type::Object;
use GraphQL::Type::Scalar;

# Definér en simpel String-type
my $StringType = GraphQL::Type::Scalar->new(
  name => 'String',
  serialize => sub { $_[0] },
);

# Definér root Query
my $query_root = GraphQL::Type::Object->new(
  name   => 'Query',
  fields => {
    hello => {
      type    => $StringType,
      resolve => sub { 'Hello from Perl GraphQL!' },
    },
    Abkat => {
      type    => $StringType,
      resolve => sub { 'DET SPILLER BAR!' }, 
    },
  },
);

# Lav et GraphQL schema
my $schema = GraphQL::Schema->new(
  query => $query_root,
);

# Tilføj plugin OG sig at det selv skal lave route!
plugin GraphQL => { schema => $schema };

# Test GET route
get '/' => { text => 'GraphQL server is AaDrunning!' };

app->start;
