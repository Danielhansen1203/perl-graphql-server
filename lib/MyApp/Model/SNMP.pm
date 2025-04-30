package MyApp::Model::SNMP;
use strict;
use warnings;
use Net::SNMP;

sub resolve_getInterfaceStatus {
  my ($root, $args, $context, $info) = @_;

  my $ip  = $args->{ip};
  my $oid = $args->{oid};  # f.eks. .1.3.6.1.2.1.2.2.1.8.1 for ifOperStatus

  my ($session, $error) = Net::SNMP->session(
    -hostname  => $ip,
    -community => 'public',
    -version   => 'snmpv2c'
  );

  return $error unless defined $session;

  my $result = $session->get_request(-varbindlist => [$oid]);
  $session->close;

  return $result->{$oid} // 'No data';
}

1;
