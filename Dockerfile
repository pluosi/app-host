FROM ruby:2.5.1

ENV RAILS_ENV production

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        imagemagick \
        libsqlite3-dev \
        nginx \
    && rm -rf /var/lib/apt/lists/*

RUN gem sources --add https://gems.ruby-china.com --remove https://rubygems.org/

RUN gem install bundler

WORKDIR /app

ADD Gemfile* ./
RUN bundle install
COPY . .
COPY docker/nginx.conf /etc/nginx/sites-enabled/app.conf

# 编译静态文件
RUN rake assets:precompile

EXPOSE 8686

CMD /bin/bash docker/check_prereqs.sh && service nginx start && puma -C config/puma.rb
