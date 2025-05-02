package MyApp;
use Mojo::Base 'Mojolicious';
use GraphQL::Schema;
use MyApp::Model::SNMP;

sub startup {
    my $self = shift;

    $self->config(
        hypnotoad => {
            listen  => ['http://*:3000'],
            workers => 2,
            proxy   => 1,
        }
    );

    # Define SDL (schema)
    my $schema = GraphQL::Schema->from_doc(<<'GRAPHQL');
type Query {
  interfaceStatus(ip: String!, oid: String!): String
  hejAbkat: String
}
GRAPHQL

    # Instantiate your SNMP model
    my $snmp = MyApp::Model::SNMP->new;

    # Root resolvers
    my $root_value = {
        interfaceStatus => sub {
            my ($args) = @_;
            return $snmp->get_interface_status($args->{ip}, $args->{oid});
        },
        hejAbkat => sub {
            my ($args) = @_;
            return "Hvis dette virker er det insane!"
        },
    };

    # Plugin
    $self->plugin('GraphQL' => {
        schema      => $schema,
        root_value  => $root_value,
    });

    # Routes
    my $r = $self->routes;
    $r->post('/graphql')->to('GraphQL#execute');
    $r->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(text => 'GraphQL server is running!');
    });
}

1;
