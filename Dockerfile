FROM ruby:3.3-bookworm

RUN apt-get update \
    && apt-get install --yes --no-install-recommends build-essential git \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /srv/jekyll

EXPOSE 4000
EXPOSE 35729

CMD ["sh", "-lc", "bundle install && bundle exec jekyll serve --host 0.0.0.0 --livereload --force_polling"]
