package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;
use GraphQL::Execution;

my $schema;

sub execute {
    my $c = shift;

    $c->app->log->debug("GraphQL query: " . ($data->{query} // '[undef]'));
    $schema ||= MyApp::Schema::Graphql::build($c->app->snmp_model);

    my $data = $c->req->json || {};

    unless ($data->{query}) {
        return $c->render(
            status => 400,
            json   => { error => 'Missing GraphQL query' }
        );
    }

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
