package MyApp::Controller::Childconnect;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json encode_json);
use FindBin;
use File::Spec;

# Beregn sti til datafil\
sub data_file {
  return File::Spec->catfile(File::Spec->rel2abs($FindBin::Bin), '..', 'data.json');
}

# Indlæs data
sub load_data {
  my $c = shift;
  my $file = $c->data_file;
  return { nodes => [], edges => [] } unless -e $file && -s $file;
  open my $fh, '<', $file or return { nodes => [], edges => [] };
  local $/;
  my $json = <$fh>;
  close $fh;
  my $data;
  eval { $data = decode_json($json) };
  return { nodes => [], edges => [] } if $@ || ref $data ne 'HASH';
  return $data;
}

# Gem data
sub save_data {
  my ($c, $data) = @_;
  my $file = $c->data_file;
  open my $fh, '>', $file or return 0;
  print $fh encode_json($data);
  close $fh;
  return 1;
}

# Del data
sub del_data {
  my ($c, $data) = @_;
  my $file = $c->data_file;
  open my $fh, '>', $file or return 0;
  print $fh "";
  close $fh;
  return 1;
}

# POST /save
sub save {
  my $c    = shift;
  my $data = decode_json $c->req->body;
  if ($c->save_data($data)) {
    $c->render(json => { status => 'ok' });
  } else {
    $c->render(status => 500, json => { status => 'error' });
  }
}

sub del {
  my $c    = shift;
  my $data = decode_json $c->req->body;
  if ($c->del_data($data)) {
    $c->render(json => { status => 'ok' });
  } else {
    $c->render(status => 500, json => { status => 'error' });
  }
}


# GET /
sub index {
  my $c    = shift;
  my $data = $c->load_data;
   $c->stash(
    nodes_json => encode_json($data->{nodes}),
    edges_json => encode_json($data->{edges}),
  );
  # Render template in 'main/' subfolder
  $c->render(template => 'childconnect/index');
}

1;