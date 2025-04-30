package MyApp::Model::SNMP;
use strict;
use warnings;
use Net::SNMP;

sub new {
    my ($class) = @_;
    return bless {}, $class;
}

sub get_sysdescr {
    my ($self, $ip) = @_;
    my ($session, $error) = Net::SNMP->session(
        -hostname  => $ip,
        -community => 'public',
        -version   => 'snmpv2c',
    );

    return undef unless $session;

    my $result = $session->get_request(-varbindlist => ['1.3.6.1.2.1.1.1.0']);  # sysDescr.0
    $session->close;

    return $result->{'1.3.6.1.2.1.1.1.0'} || 'unknown';
}

1;
