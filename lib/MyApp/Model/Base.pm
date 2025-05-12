package MyApp::Model::Base;
use Mojo::Base -base;
use FindBin;
use File::Spec;
use Mojo::UserAgent;

has 'app';      # Mojolicious application object
has 'logger';   # Shortcut to app->log

sub new {
    my ($class, $app, %args) = @_;
    my $self = bless {}, $class;
    # Store app and logger
    $self->app($app);
    $self->logger($app->log);
    # Setup UA and default API config if provided
    $self->$_($args{$_}) for keys %args;
    return $self;
}

1;