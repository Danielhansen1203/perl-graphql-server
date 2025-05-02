package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;
use GraphQL::Execution;
use Data::Dumper;

my $schema;

sub execute {
    my $c = shift;
    $schema ||= MyApp::Schema::Graphql::build($c->app->snmp_model);

    my $data = $c->req->json || {};
    

    # Undgå fejl hvis operationName er et hash
    my $opname = $data->{operationName};
    $opname = undef unless defined($opname) && !ref($opname);

my $result = GraphQL::Execution::execute(
    $schema->{schema},
    $data->{query},
    undef,
    undef,
    $data->{variables} || {},
    $schema->{root_value}
);

    $c->render(json => $result);
    $c->app->log->debug("RAW JSON data: " . Dumper($c->render(json => $result)));
}

1;
