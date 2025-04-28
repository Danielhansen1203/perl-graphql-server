FROM perl:5.36

RUN apt-get update && apt-get install -y build-essential libssl-dev libperl-dev zlib1g-dev curl make gcc

# Installer cpanminus
RUN curl -L https://cpanmin.us | perl - App::cpanminus

# Installer alle nødvendige Perl moduler
RUN cpanm --notest Moo Role::Tiny JSON::MaybeXS Try::Tiny Sub::Util Module::Runtime

# Installer GraphQL (som nu virker)
RUN cpanm --notest GraphQL

# Installer Mojolicious + Plugin
RUN cpanm --notest Mojolicious Mojolicious::Plugin::GraphQL

WORKDIR /app

COPY myapp.pl .

EXPOSE 3000

CMD ["morbo", "-l", "http://0.0.0.0:3000", "myapp.pl"]
