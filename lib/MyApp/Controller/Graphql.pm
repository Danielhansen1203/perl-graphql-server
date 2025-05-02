package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;
use GraphQL::Execution;
use Data::Dumper;

my $schema;

sub execute {
    my $c = shift;
warn "kommer jeg ind ?";
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
warn "Step 1";

    $c->render(json => $result);
}

1;
