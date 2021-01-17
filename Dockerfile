FROM ruby:2.6.6

ENV LANG C.UTF-8

RUN apt update
RUN apt install -y nodejs npm vim

# yarnのバグに対応するために安定版を取得してインストールする
RUN apt remove -y cmdtest yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update
RUN apt install -y yarn

WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# railsのインストール
RUN gem install rails
RUN bundle config --global build.nokogiri --use-system-libraries && \
    gem update bundler && bundle install

RUN rails webpacker:install
RUN yarn install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
