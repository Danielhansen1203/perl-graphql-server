package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;
use GraphQL::Execution;

# Kun én gang – schema er statisk
my $schema = MyApp::Schema::Graphql::schema();  # <--- kun SDL og typer

sub execute {
    my $c = shift;

    my $root_value = MyApp::Schema::Graphql::build_root($c);  # <- nyt hver gang

    my $data = $c->req->json || {};

    my $result = GraphQL::Execution::execute(
        $schema,
        $data->{query},
        $root_value,
        { context => $c },
        $data->{variables} || {},
        $data->{operationName}
    );

    $c->render(json => $result);
}

1;
