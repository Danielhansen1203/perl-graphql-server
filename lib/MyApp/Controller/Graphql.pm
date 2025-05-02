package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;

my $schema;

sub execute {
    my $c = shift;

    $schema ||= MyApp::Schema::Graphql::build();  # eller graphql_schema()

    my $data = $c->req->json;

    my $result = $schema->{schema}->execute(
        $data->{query},
        undef,
        undef,
        $data->{variables} || {},
        $schema->{root_value}
    );

    $c->render(json => $result);
}

1;
