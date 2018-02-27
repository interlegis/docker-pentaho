FROM openjdk:8-jre-slim

MAINTAINER Matheus Garcia matheusg@interlegis.leg.br

# Init ENV
ENV PENTAHO_HOME /opt/pentaho

# Apply JAVA_HOME
RUN . /etc/environment
ENV PENTAHO_JAVA_HOME $JAVA_HOME
ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64

# Install Dependences
RUN apt-get update; apt-get install zip netcat -y; \
    apt-get install wget unzip git postgresql-client-9.4 vim -y; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#    curl -O https://bootstrap.pypa.io/get-pip.py; \
#    python get-pip.py; \
#    pip install awscli; \
#    rm -f get-pip.py

RUN mkdir ${PENTAHO_HOME}; useradd -s /bin/bash -d ${PENTAHO_HOME} pentaho; chown pentaho:pentaho ${PENTAHO_HOME}

USER pentaho

# Download Pentaho BI Server
RUN /usr/bin/wget --progress=dot:giga https://downloads.sourceforge.net/project/pentaho/Pentaho%208.0/server/pentaho-server-ce-8.0.0.0-28.zip -O /tmp/pentaho-server.zip 
#COPY pentaho-server-ce-8.0.0.0-28.zip /tmp/pentaho-server.zip

RUN /usr/bin/unzip -q /tmp/pentaho-server.zip -d  $PENTAHO_HOME; \
    rm -f /tmp/pentaho-server.zip $PENTAHO_HOME/pentaho-server/promptuser.sh; \
    sed -i -e 's/\(exec ".*"\) start/\1 run/' $PENTAHO_HOME/pentaho-server/tomcat/bin/startup.sh; \
    chmod +x $PENTAHO_HOME/pentaho-server/start-pentaho.sh

#COPY config $PENTAHO_HOME/config
#COPY scripts $PENTAHO_HOME/scripts

WORKDIR /opt/pentaho 
EXPOSE 8080 
ENV PENTAHO_JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64
CMD ["sh", "pentaho-server/start-pentaho.sh"]
