package MyApp::Model::Data;
use Mojo::Base -strict;
use Mojo::JSON qw(decode_json encode_json);

sub new {
  my $class = shift;
  my $self  = bless {}, $class;
  return $self;
}

sub file {
  my $self = shift;
  return shift->app->home->rel_file('data.json');
}

sub load {
  my $self = shift;
  my $file = $self->file;
  return { nodes => [], edges => [] } unless -e $file;
  open my $fh, '<', $file or return { nodes => [], edges => [] };
  local $/;
  my $json = <$fh>;
  close $fh;
  return decode_json($json);
}

sub save {
  my ($self, $data) = @_;
  my $file = $self->file;
  open my $fh, '>', $file or return 0;
  print $fh encode_json($data);
  close $fh;
  return 1;
}

1;