package MyApp;
use Mojo::Base 'Mojolicious';

sub startup {
    my $self = shift;

    # Router
    my $r = $self->routes;

    # Route til GraphQL
    $r->post('/graphql')->to('graphql#graphql');

    # (andre routes, hvis du vil tilføje)
}

1;
