FROM perl:5.36

# Installer nødvendige OS-pakker
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libperl-dev \
    zlib1g-dev \
    curl \
    make \
    gcc

# Installer cpanminus
RUN curl -L https://cpanmin.us | perl - App::cpanminus

# Sæt arbejdsmappen
WORKDIR /app

# Kopier projektfiler
COPY . .

# Installer Perl moduler baseret på cpanfile
RUN cpanm --notest --installdeps .

# Eksponer porten til Mojolicious app
EXPOSE 3000

# Start med Hypnotoad (production server)
CMD ["hypnotoad", "-l", "http://*:3000", "myapp.pl"]
