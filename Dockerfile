FROM phusion/baseimage:latest
MAINTAINER Ximbesto

RUN apt-get update
RUN apt-get install -y squid-deb-proxy-client wget 

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E1DF1F24
RUN echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv C3173AA6
RUN echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv C300EE8C
RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" >> /etc/apt/sources.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update
RUN apt-get install -y supervisor logrotate locales
RUN apt-get install -y nginx openssh-server mysql-client postgresql-client redis-tools
RUN apt-get install -y git-core ruby2.1 python2.7 python-docutils
RUN apt-get install -y libmysqlclient18 libpq5 zlib1g libyaml-0-2 libssl1.0.0
RUN apt-get install -y libgdbm3 libreadline6 libncurses5 libffi6
RUN apt-get install -y libxml2 libxslt1.1 libcurl3 libicu52
RUN update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales
RUN gem install --no-document bundler
RUN rm -rf /var/lib/apt/lists/* # 20150220

COPY assets/setup/ /app/setup/
RUN chmod 755 /app/setup/install
RUN /app/setup/install

COPY assets/config/ /app/setup/config/
COPY assets/init /app/init
RUN chmod 755 /app/init

EXPOSE 22
EXPOSE 80
EXPOSE 443

VOLUME ["/home/git/data"]
VOLUME ["/var/log/gitlab"]
CMD ["/sbin/my_init"]
ENTRYPOINT ["/app/init"]
CMD ["app:start"]



#ENV DEBIAN_FRONTEND noninteractive
#RUN apt-get install -y openssh-client
#RUN apt-get install -y openjdk-6-jre
#RUN apt-get install -y default-jre
#RUN apt-get install -y curl
#RUN apt-get install -y nmap
#RUN apt-get install -y unzip
#ADD http://192.168.100.222/forgerock/OpenDJ-2.6.0.zip /
#ADD OpenDJ-2.6.0.zip /
#RUN useradd -d /var/lib/opendj -m -s /bin/bash opendj
#RUN chown opendj:opendj /OpenDJ-2.6.0.zip
#RUN su -s /bin/bash opendj -c "unzip /OpenDJ-2.6.0.zip -d /var/lib/"
#RUN rm -rf /OpenDJ-2.6.0.zip
#ADD opendj.properties /var/lib/opendj/opendj.properties
#RUN echo 'foo' > /tmp/foo.txt
#RUN su -s /bin/bash opendj -c "cd /var/lib/opendj;./setup  --cli --propertiesFilePath #opendj.properties --acceptLicense --no-prompt "
#RUN cd /var/lib/opendj;./setup  --cli --propertiesFilePath opendj.properties --acceptLicense --no-prompt
#RUN echo 'bar' >> /tmp/foo.txt
#RUN /usr/sbin/enable_insecure_key
#RUN mkdir /etc/service/opendj
#ADD opendj.sh /etc/service/opendj/run
#RUN chmod +x /etc/service/opendj/run
#EXPOSE 389 1686 1689 8080 4444
#CMD ["./var/lib/opendj/bin/start-ds"]
#docker run  -p 389:389 -p 4444:4444 -p 1689:1689 -p 1686:1686 -v /opt/opendj1/db:/var/lib/opendj/db:rw -v /opt/opendj1/log:/var/lib/opendj/log:rw   --name name-xim-opendj-sample --restart=always  -d xim-opendj-sample
#docker run  -p 389:389 -p 4444:4444 -p 1689:1689 -p 1686:1686 -v /opt/opendj2:/var/lib/opendj:rw  --name name-xim-opendj-sample --restart=always  -d xim-opendj-sample
#docker run  -p 389:389 -p 4444:4444 -p 1689:1689 -p 1686:1686 --name name-xim-opendj-sample --restart=always  -d xim-opendj-sample
