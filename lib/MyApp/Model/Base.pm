package MyApp::Model::Base;

sub new {
    my ($class, %args) = @_;
    return bless {
        logger => $args{logger},
    }, $class;
}

1;