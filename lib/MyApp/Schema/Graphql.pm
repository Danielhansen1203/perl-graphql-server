package MyApp::Schema::Graphql;
use Moo;
use GraphQL::Plugin::Convert qw(to_graphql);

sub graphql_schema {
    my ($self) = @_;

    return to_graphql([{
        temperature => {
            args => { ip => { type => 'String!' } },
            type => 'Float',
            resolve => sub {
                my ($root, $args) = @_;
                return 22.5; # dummy data
            },
        },
        ports => {
            args => { ip => { type => 'String!' } },
            type => ['Port'],
            resolve => sub {
                my ($root, $args) = @_;
                return [
                    { name => 'eth0', status => 'up' },
                    { name => 'eth1', status => 'down' },
                ];
            },
        },
    }], [qw(Port name status)]);
}

1;
