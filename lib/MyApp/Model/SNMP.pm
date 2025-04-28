package MyApp::Model::SNMP;
use strict;
use warnings;
use Net::SNMP;

sub new {
    my ($class, %args) = @_;
    my $self = {
        community => $args{community} || 'public',
        version   => $args{version}   || 'snmpv2c',
    };
    bless $self, $class;
    return $self;
}

sub get_temperature {
    my ($self, $ip) = @_;

    my ($session, $error) = Net::SNMP->session(
        -hostname  => $ip,
        -community => $self->{community},
        -version   => $self->{version},
    );
    die "SNMP session error: $error" unless defined $session;

    my $oid_temperature = '1.3.6.1.4.1.9.9.13.1.3.1.3.1'; # eksempel

    my $result = $session->get_request(-varbindlist => [$oid_temperature]);
    $session->close;

    return unless defined $result;
    return $result->{$oid_temperature} * 1.0;
}

sub get_ports_in_use {
    my ($self, $ip) = @_;

    my ($session, $error) = Net::SNMP->session(
        -hostname  => $ip,
        -community => $self->{community},
        -version   => $self->{version},
    );
    die "SNMP session error: $error" unless defined $session;

    my $oid_ifDescr = '1.3.6.1.2.1.2.2.1.2';
    my $oid_ifOperStatus = '1.3.6.1.2.1.2.2.1.8';

    my $names = $session->get_table(-baseoid => $oid_ifDescr);
    my $statuses = $session->get_table(-baseoid => $oid_ifOperStatus);

    $session->close;

    my @ports;
    foreach my $oid (keys %$names) {
        my ($ifIndex) = $oid =~ /\.(\d+)$/;
        push @ports, {
            name   => $names->{$oid},
            status => _translate_status($statuses->{"$oid_ifOperStatus.$ifIndex"}),
        };
    }

    return \@ports;
}

sub _translate_status {
    my ($code) = @_;
    return 'up' if $code == 1;
    return 'down' if $code == 2;
    return 'testing' if $code == 3;
    return 'unknown';
}

1;
