FROM openjdk:8-jre-slim

MAINTAINER Matheus Garcia matheusg@interlegis.leg.br

# Init ENV
ENV PENTAHO_HOME /opt/pentaho

# Apply JAVA_HOME
RUN . /etc/environment
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64

# Install Dependences
RUN apt-get update; apt-get install zip netcat -y; \
    apt-get install wget unzip git vim -y; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir ${PENTAHO_HOME}; useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; chown pentaho:pentaho ${PENTAHO_HOME}

COPY accessibility.properties /etc/java-8-openjdk/

USER pentaho

# Download Pentaho BI Server
RUN wget --progress=dot:giga https://downloads.sourceforge.net/project/pentaho/Pentaho%208.1/server/pentaho-server-ce-8.1.0.0-365.zip -O /tmp/pentaho-server.zip 

RUN /usr/bin/unzip -q /tmp/pentaho-server.zip -d  $PENTAHO_HOME; \
    rm -f /tmp/pentaho-server.zip $PENTAHO_HOME/pentaho-server/promptuser.sh; \
    sed -i -e 's/\(exec ".*"\) start/\1 run/' $PENTAHO_HOME/pentaho-server/tomcat/bin/startup.sh; \
    chmod +x $PENTAHO_HOME/pentaho-server/start-pentaho.sh

EXPOSE 8080 

CMD ["sh", "/opt/pentaho/pentaho-server/start-pentaho.sh"]
