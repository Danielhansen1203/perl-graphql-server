package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;

my $schema;

sub graphql {
    my $c = shift;

    $schema ||= MyApp::Schema::Graphql->graphql_schema($c->app->snmp_model);

    my $data = $c->req->json // {};

    my $result = $schema->execute(
        $data->{query},
        undef,
        undef,
        $data->{variables} || {}
    );

    $c->render(json => $result);
}

1;
