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

 
 my $schema = GraphQL::Schema->from_doc(<<'EOF');
type User {
  id: String
  name: String
}
type Query {
  user(id: String): User
}
EOF
my $fakedb = {
  a => { id => 'a', name => 'alice' },
  b => { id => 'b', name => 'bob' },
};

my $root_value = {
  user => sub {
    my $id = shift->{id};
    die "No user $id\n" if !$fakedb->{$id};
    $fakedb->{$id}
  },
};

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
