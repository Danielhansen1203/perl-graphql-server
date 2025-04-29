package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;

my $schema;

sub graphql {
    my $c = shift;

    $schema ||= MyApp::Schema::Graphql->new->graphql_schema;

    my $data = $c->req->json;

    my $result = $schema->execute(
        $data->{query},
        undef,
        undef,
        $data->{variables} || {}
    );

    $c->render(json => $result);
}

1;
