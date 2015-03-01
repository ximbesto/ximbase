FROM phusion/baseimage:latest
MAINTAINER Ximbesto

RUN apt-get update
RUN apt-get install -y squid-deb-proxy-client wget curl nmap default-jdk openssh-server unzip




