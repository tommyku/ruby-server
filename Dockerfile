FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y update && \
	apt-get -y install git build-essential ruby-dev ruby-rails libz-dev libmysqlclient-dev curl && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -

RUN apt-get install -y nodejs

RUN npm install -g bower

ADD ./ /data/src/

WORKDIR /data/src/

RUN bower install --allow-root

RUN bundle install

RUN bundle exec rake assets:precompile

CMD ./bin/run
