FROM perl:5.36

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libperl-dev \
    pkg-config \
    libexpat1-dev \
    curl \
    make \
    gcc

RUN curl -L https://cpanmin.us | perl - App::cpanminus

WORKDIR /app
COPY . .

RUN cpanm --notest Mojolicious GraphQL GraphQL::Plugin::Convert Mojolicious::Plugin::GraphQL JSON::MaybeXS Try::Tiny Moo Role::Tiny

ENV PERL5LIB=/app/lib
EXPOSE 3000

CMD ["perl", "myapp.pl"]
