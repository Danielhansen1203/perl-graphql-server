package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Model::SNMP;
use MyApp::Schema::Graphql;

# Kunne caches hvis nødvendigt
my $schema;

sub graphql {
    my $c = shift;

    $schema ||= MyApp::Schema::Graphql::schema(MyApp::Model::SNMP->new);

    my $result = $schema->execute(
        $c->req->json->{query},
        undef,
        undef,
        $c->req->json->{variables},
    );

    $c->render(json => $result);
}

1;
