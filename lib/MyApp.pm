package MyApp;
use Mojo::Base 'Mojolicious';

use GraphQL::Schema;
use GraphQL::Type::Object;
use GraphQL::Type::Scalar;
use GraphQL::Execution;

sub startup {
    my $self = shift;

    $self->config(
        hypnotoad => {
            listen  => ['http://*:3000'],
            workers => 2,
            proxy   => 1,
        }
    );

    my $query = GraphQL::Type::Object->new(
        name   => 'Query',
        fields => {
            hello => {
                type    => GraphQL::Type::Scalar->new(name => 'String'),
                resolve => sub { return "Hello World!" },
            },
        },
    );

    my $schema = GraphQL::Schema->new(query => $query);

    $self->plugin('GraphQL' => {
        schema    => $schema,
        serialize => \&GraphQL::Execution::serialize,
    });

    my $r = $self->routes;
    $r->post('/graphql')->to('GraphQL#execute');
    $r->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(text => 'GraphQL server is running!');
    });
}

1;
