FROM perl:5.36

# Installér nødvendige OS-pakker
RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libperl-dev \
    zlib1g-dev \
    curl \
    make \
    gcc

# Installér cpanminus
RUN curl -L https://cpanmin.us | perl - App::cpanminus

# Arbejdsmappe
WORKDIR /app

# Kopier kode
COPY . .

# Installér Perl dependencies
RUN cpanm --notest --installdeps .

# Sæt port
EXPOSE 3000

# Sæt environment variable for Mojolicious
ENV MOJO_LISTEN=http://*:3000

# Start hypnotoad
CMD ["hypnotoad", "myapp.pl"]
