package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;

my $schema = MyApp::Schema::Graphql::schema();

sub graphql {
    my $c = shift;

    my $data = $c->req->json;

    my $result = $schema->execute(
        $data->{query},
        undef,
        undef,
        $data->{variables} || {}
    );

    $c->render(json => $result);
}

1;
