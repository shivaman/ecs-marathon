FROM maven:3-jdk-7

RUN \
    echo "networkaddress.cache.ttl=0" >> /etc/java-7-openjdk/security/java.security \
    && sed -i 's/networkaddress.cache.negative.ttl=10/networkaddress.cache.negative.ttl=0/g' /etc/java-7-openjdk/security/java.security

ENV \
    ZK_VERSION="3.4.6" \
    EXHIBITOR_VERSION="1.5.6"

ENV \
    ZK_RELEASE="http://www.apache.org/dist/zookeeper/zookeeper-$ZK_VERSION/zookeeper-$ZK_VERSION.tar.gz" \
    EXHIBITOR_POM="https://raw.githubusercontent.com/Netflix/exhibitor/v$EXHIBITOR_VERSION/exhibitor-standalone/src/main/resources/buildscripts/standalone/maven/pom.xml"

RUN \
    curl -Lo /tmp/zookeeper.tgz $ZK_RELEASE \
    && mkdir -p /opt/zookeeper/transactions /opt/zookeeper/snapshots \
    && tar -xzf /tmp/zookeeper.tgz -C /opt/zookeeper --strip=1 \
    && rm /tmp/zookeeper.tgz \
    && mkdir -p /opt/exhibitor \
    && curl -Lo /opt/exhibitor/pom.xml $EXHIBITOR_POM \
    && mvn -f /opt/exhibitor/pom.xml package \
    && ln -s /opt/exhibitor/target/exhibitor*jar /opt/exhibitor/exhibitor.jar

COPY entrypoint.sh /usr/bin/exhibitor

USER root
WORKDIR /opt/exhibitor

ENV \
    ZK_CONNECT_PORT=2888 \
    ZK_ELECTION_PORT=3888 \
    ZK_CLIENT_PORT=2181 \
    EXHIBITOR_PORT=8181 \
    ENSEMBLE_SIZE=1

ENTRYPOINT ["exhibitor"]
