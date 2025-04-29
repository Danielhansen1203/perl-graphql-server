package MyApp::Schema::Graphql;
use strict;
use warnings;
use Moo;
use GraphQL::Plugin::Convert qw(to_graphql);

# Moo-style Objekt
has snmp_model => (is => 'ro');

sub graphql_schema {
    my ($self) = @_;

    return to_graphql([{
        temperature => {
            args => { ip => { type => 'String!' } },
            type => 'Float',
            resolve => sub {
                my ($root, $args, $context, $info) = @_;
                return 22.5; # Dummy temperatur
            }
        },
        ports => {
            args => { ip => { type => 'String!' } },
            type => ['Port'],
            resolve => sub {
                my ($root, $args, $context, $info) = @_;
                return [
                    { name => 'eth0', status => 'up' },
                    { name => 'eth1', status => 'down' },
                ];
            }
        }
    }], [qw(Port name status)]);
}

1;
