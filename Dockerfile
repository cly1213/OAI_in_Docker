FROM ubuntu:18.04
MAINTAINER leo

RUN apt-get update
RUN apt-get install net-tools vim git iputils-ping sudo software-properties-common git wget psmisc -y

RUN cd ~


