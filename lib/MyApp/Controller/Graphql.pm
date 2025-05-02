package MyApp::Controller::Graphql;
use Mojo::Base 'Mojolicious::Controller';
use MyApp::Schema::Graphql;
use GraphQL::Execution;
use Data::Dumper;

sub execute {
  my $c      = shift;
  my $body   = $c->req->json;               # JSON-indhold fra klienten
  my $query  = $body->{query};
  my $vars   = $body->{variables} || {};    # eventuelle variabler
  my $opname = $body->{operationName};      # operationName fra input
  
  warn "operationName: ", Dumper($opname);  # Debug: log værdien af operationName
  
  my $result = GraphQL::Execution->execute(
      $schema,
      $query,
      $root_value,
      undef,               # kontekst (f.eks. $c->req->headers eller undef)
      $vars,
      $opname,             # operationName parameteren
      undef                # field resolver (valgfrit)
  );
  $c->render(json => $result);
}


1;
