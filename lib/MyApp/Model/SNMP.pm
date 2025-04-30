package MyApp::Model::SNMP;
use strict;
use warnings;
use Net::SNMP;

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub get_interface_status {
    my ($self, $ip, $oid) = @_;

    my ($session, $error) = Net::SNMP->session(
        -hostname  => $ip,
        -community => 'public',
        -version   => 'snmpv2c',
        -timeout   => 2,
    );

    return "SNMP Error: $error" unless $session;

    my $result = $session->get_request(-varbindlist => [$oid]);
    $session->close;

    return $result->{$oid} // 'No data';
}

1;
