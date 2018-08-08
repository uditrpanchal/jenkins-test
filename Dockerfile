FROM ubuntu:16.04
LABEL maintainer "<Udit Panchal udit.panchal@gmail.com>"

RUN mkdir /usr/local/java && \
    apt-get update && \
    apt-get install -y curl wget && \
    apt-get install -y vim

COPY jdk-8u181-linux-x64.tar.gz /usr/local/java
RUN cd /usr/local/java && tar -xzf jdk-8u181-linux-x64.tar.gz && rm jdk-8u181-linux-x64.tar.gz
ENV JAVA_HOME /usr/local/java/jdk1.8.0_181
ENV PATH ${JAVA_HOME}/bin:${PATH}

RUN cd /usr/local/ && \
    wget http://mirror.its.dal.ca/apache/tomcat/tomcat-9/v9.0.10/bin/apache-tomcat-9.0.10.tar.gz && \
    tar -zxf apache-tomcat-9.0.10.tar.gz && \
    mv apache-tomcat-9.0.10 tomcat && \
    rm apache-tomcat-9.0.10.tar.gz

ENV CATALINA_HOME /usr/local/tomcat
ENV CATALINA_BASE /usr/local/tomcat
ENV CATALINA_TMPDIR /usr/local/tomcat/temp
ENV JRE_HOME /usr/local/java/jdk1.8.0_181
ENV CLASSPATH /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar

COPY openid-connect-server-webapp.war /usr/local/tomcat/webapps
     

RUN cd /usr/local && \
    touch script.sh && \
    printf '#!/bin/sh\nbash /usr/local/tomcat/bin/startup.sh && tail -f /usr/local/tomcat/logs/catalina.out' > script.sh

RUN chmod u+x /usr/local/script.sh


EXPOSE 8005
EXPOSE 8080


CMD ["/bin/bash","-c","/usr/local/script.sh"]
