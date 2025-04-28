FROM perl:5.36

RUN apt-get update && apt-get install -y \
    build-essential \
    libssl-dev \
    libperl-dev \
    zlib1g-dev \
    curl \
    make \
    gcc

RUN curl -L https://cpanmin.us | perl - App::cpanminus

WORKDIR /app

COPY . .

RUN cpanm --notest --installdeps .

EXPOSE 3000

CMD ["hypnotoad", "myapp.pl"]
