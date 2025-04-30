package MyApp;
use Mojo::Base 'Mojolicious';
use GraphQL::Schema;

sub startup {
    my $self = shift;

    $self->config(
        hypnotoad => {
            listen  => ['http://*:3000'],
            workers => 2,
            proxy   => 1,
        }
    );

    my $schema = GraphQL::Schema->from_doc(
        <<'EOF',
type User {
  id: String
  name: String
}
type Query {
  user(id: String): User
}
EOF
        ,
        {
            user => sub {
                my ($root, $args) = @_;
                return {
                    id   => $args->{id},
                    name => "Hardcoded User"
                };
            }
        }
    );

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
