package MyApp;
use Mojo::Base 'Mojolicious';

use GraphQL::Plugin::Convert ();  # <-- Brug uden qw(), vi kalder direkte

sub startup {
    my $self = shift;

    $self->config(
        hypnotoad => {
            listen  => ['http://*:3000'],
            workers => 2,
            proxy   => 1,
        }
    );

    # Brug to_graphql med fuldt navn
    my $schema = GraphQL::Plugin::Convert::to_graphql([
        {
            hello => {
                type => 'String',
                resolve => sub {
                    return "Hello from GraphQL!";
                },
            },
        }
    ]);

    $self->plugin('GraphQL' => {
        schema => $schema,
    });

    my $r = $self->routes;
    $r->post('/graphql')->to('GraphQL#execute');
    $r->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(text => 'GraphQL server is running!');
    });
}

1;
