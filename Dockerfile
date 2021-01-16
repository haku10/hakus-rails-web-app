FROM ruby:2.6.6

ENV LANG C.UTF-8
RUN apt update \
    && apt upgrade
RUN apt install -y nodejs yarn
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# railsのインストール
RUN gem install rails
RUN bundle config --global build.nokogiri --use-system-libraries && \
    bundle install --jobs=4

RUN rails webpacker:install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
