package MyApp::Schema::Graphql;
use strict;
use warnings;
use GraphQL::Schema;
use GraphQL::Type::Object;
use GraphQL::Type::Scalar;

sub schema {
    my ($snmp_model) = @_;

    my $Query = GraphQL::Type::Object->new(
        name => 'Query',
        fields => {
            temperature => {
                type => GraphQL::Type::Scalar->new(name => 'Float'),
                args => { ip => { type => GraphQL::Type::Scalar->new(name => 'String') } },
                resolve => sub {
                    my ($root, $args, $context, $info) = @_;
                    return 22.5; # dummy temperatur
                },
            },
            ports => {
                type => GraphQL::Type::List->new(of => GraphQL::Type::Object->new(
                    name => 'Port',
                    fields => {
                        name => { type => GraphQL::Type::Scalar->new(name => 'String') },
                        status => { type => GraphQL::Type::Scalar->new(name => 'String') },
                    }
                )),
                args => { ip => { type => GraphQL::Type::Scalar->new(name => 'String') } },
                resolve => sub {
                    my ($root, $args, $context, $info) = @_;
                    return [
                        { name => "eth0", status => "up" },
                        { name => "eth1", status => "down" },
                    ];
                },
            },
        }
    );

    return GraphQL::Schema->new(query => $Query);
}

1;
