FROM ruby:2.5
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN addgroup --gid $GROUP_ID user
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user
USER user

COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp


ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000


CMD ["rails", "server", "-b", "0.0.0.0"]

