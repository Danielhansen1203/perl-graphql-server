package MyApp;
use Mojo::Base 'Mojolicious';
use FindBin;
use File::Spec;

sub startup {
  my $self = shift;

  # Beregn absolut sti til projektets rod (én mappe over bin/)
  my $root = File::Spec->rel2abs( File::Spec->catdir($FindBin::Bin, '..') );
  $self->plugin(Config => { file => $self->home->rel_file('config/myapp.conf') });

  # Fortæl Mojolicious, hvor dine public-filer og templates ligger
  $self->static->paths->[0]   = File::Spec->catdir($root, 'public');
  $self->renderer->paths->[0] = File::Spec->catdir($root, 'templates');

    $self->helper(
    homeassist => sub { MyApp::Model::Homeassist->new(shift->app) },
    snmp_model => sub { MyApp::Model::SNMP->new(shift->app) },
  );

  # Ruter
  my $r = $self->routes;
  $r->get('/')->to('main#index');
  $r->get('/childconnect')->to('childconnect#index');
  $r->post('/childconnect/save')->to('childconnect#save');
  $r->post('/childconnect/del')->to('childconnect#del');


  # GraphQL endpoint
  $r->get('/graphql')->to('graphql#index');
  $r->post('/graphql')->to('graphql#execute');

  
}

1;
