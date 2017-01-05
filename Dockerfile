FROM ubuntu:14.04

LABEL description="Jenkins with jd8 and Maven 3"

MAINTAINER hshekha <himanshu.3.shekhar@bt.com>

ARG MAVEN_VERSION=3.3.9 
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN apt-get update

RUN apt-get install -y wget

#Install Maven
COPY installers/apache-maven-$MAVEN_VERSION-bin.tar.gz /tmp/
RUN tar -xvf /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-$MAVEN_VERSION /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-$MAVEN_VERSION.tar.gz
ENV MAVEN_HOME /opt/maven

# install git
RUN apt-get install -y git

# install nano
RUN apt-get install -y nano

# remove download archive files
RUN apt-get clean

# Install Java 8
COPY installers/jdk-8u101-linux-x64.tar.gz /tmp/jdk-8u101-linux-x64.tar.gz
RUN mkdir /opt/java-oracle
RUN tar -xvf /tmp/jdk-8u101-linux-x64.tar.gz -C /opt/java-oracle/
ENV JAVA_HOME /opt/java-oracle/jdk1.8.0_101
ENV PATH $JAVA_HOME/bin:$PATH

RUN rm /tmp/jdk-8u101-linux-x64.tar.gz

RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

ENV JENKINS_HOME /jenkins_home
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

#Install Jenkins
COPY installers/jenkins.war /opt/jenkins.war
RUN chown ${user}:${gid} /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war

# expose for main web interface:
EXPOSE 8080
# expose for attaching slave agents:
EXPOSE 50000

#USER ${user}

RUN echo "Europe/London" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]

CMD [""]





