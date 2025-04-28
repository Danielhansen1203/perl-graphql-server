sub startup {
    my $self = shift;

    my $r = $self->routes;

    # GraphQL route
    $r->post('/graphql')->to('graphql#graphql');

    # Ekstra default route (valgfri, men hjælper hypnotoad at holde sig i live)
    $r->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(text => 'GraphQL server running');
    });
}
