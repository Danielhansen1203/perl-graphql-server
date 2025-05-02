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
    $root_value,                      # 3. param: root_value
    undef,                            # 4. context_value
    $data->{variables} || {},         # 5. variables
    $opname                           # 6. operationName
);




    $c->render(json => $result);
}

1;
