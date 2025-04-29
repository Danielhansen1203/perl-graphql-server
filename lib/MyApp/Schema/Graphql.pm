package MyApp::Schema::Graphql;
use strict;
use warnings;
use GraphQL::Schema;

sub schema {
    return GraphQL::Schema->from_doc(<<'GRAPHQL', {
        hello => sub { "Hello World" },
    });
}

1;

__DATA__

GRAPHQL
type Query {
  hello: String
}
GRAPHQL
