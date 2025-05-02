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

    use Data::Dumper;
    $c->app->log->debug("RAW JSON data: " . Dumper($data));

    unless ($data->{query} && $data->{query} =~ /\S/) {
        return $c->render(
            status => 400,
            json   => { error => 'Missing or empty GraphQL query' }
        );
    }

    $c->app->log->debug("GraphQL query: " . ($data->{query} // '[undef]'));

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
