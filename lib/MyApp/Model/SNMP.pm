package MyApp::Model::SNMP;
use strict;
use warnings;

sub new { bless {}, shift }

# Fake metoder
sub get_temperature {
    my ($self, $ip) = @_;
    return 22.5;
}

sub get_ports_in_use {
    my ($self, $ip) = @_;
    return [
        { name => 'port1', status => 'up' },
        { name => 'port2', status => 'down' },
    ];
}

1;
