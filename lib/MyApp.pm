package MyApp;
use Mojo::Base 'Mojolicious';
use MyApp::Schema::Graphql;
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

    # Helper til SNMP-model
    $self->helper(snmp_model => sub { MyApp::Model::SNMP->new });

    # Routes
    my $r = $self->routes;
    $r->post('/graphql')->to('graphql#graphql');
}

1;
