package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;
use GraphQL::Execution;
use Data::Dumper;

my $compiled_schema;  # Holder på schema og root_value

sub execute {
    my $c = shift;

    $compiled_schema ||= MyApp::Schema::Graphql::build($c->app->snmp_model);

    my $schema     = $compiled_schema->{schema};
    my $root_value = $compiled_schema->{root_value};

    my $data = $c->req->json || {};

    $c->app->log->debug("RAW JSON data: " . Dumper($data));

    my $opname = $data->{operationName};
    $opname = undef unless defined($opname) && !ref($opname);
    warn "operationName: ", Dumper($opname);

    my $result = GraphQL::Execution::execute(
        $schema,
        $data->{query},
        $opname,
        undef,
        $data->{variables} || {},
        $root_value
    );

    $c->render(json => $result);
}

1;
