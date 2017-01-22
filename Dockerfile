FROM ubuntu:latest

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y update && \
	apt-get -y install git build-essential ruby-dev ruby-rails libz-dev libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean

ADD ./ /data/src/

WORKDIR /data/src/

RUN bundle install

CMD rails db:create db:migrate && rails s -b 0.0.0.0
