package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;
use GraphQL::Execution;

my $schema;

sub execute {
    my $c = shift;

    $schema ||= MyApp::Schema::Graphql::build($c->app->snmp_model);

    my $data = $c->req->json;

    my $result = GraphQL::Execution::execute(
        $schema->{schema},
        $data->{query},
        undef,
        undef,
        $data->{variables} || {},
        $schema->{root_value}
    );

    $c->render(json => $result);
}

1;
