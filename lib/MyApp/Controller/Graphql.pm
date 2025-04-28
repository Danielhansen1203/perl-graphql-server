package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Model::SNMP;
use MyApp::Schema::Graphql;
use GraphQL::Execution qw(execute);

sub graphql {
    my $c = shift;

    my $snmp_model = MyApp::Model::SNMP->new();
    my $schema = MyApp::Schema::Graphql::schema($snmp_model);

    my $query = $c->req->json->{query};
    my $variables = $c->req->json->{variables} || {};

    my $result = execute($schema, $query, undef, undef, $variables);

    $c->render(json => $result);
}

1;