package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';

use MyApp::Model::SNMP;
use MyApp::Schema::Graphql;

my $schema;

sub graphql {
    my $c = shift;

    # Lav schema hvis det ikke allerede eksisterer
    $schema ||= MyApp::Schema::Graphql::schema(MyApp::Model::SNMP->new);

    # Parse incoming query
    my $data = $c->req->json;

    my $result = $schema->execute(
        $data->{query},
        undef,
        undef,
        $data->{variables} || {}
    );

    # Returnér resultat som JSON
    $c->render(json => $result);
}

1;
