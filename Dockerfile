FROM openjdk:8u322-jre-bullseye AS download

ENV LC_ALL=C

ARG GIT_BRANCH=local
ARG GIT_REVISION=local

ENV SCHEMASPY_VERSION=6.1.0
ENV MYSQL_VERSION=8.0.28
ENV MARIADB_VERSION=1.1.10
ENV POSTGRESQL_VERSION=42.2.25
ENV JTDS_VERSION=1.3.1

LABEL MYSQL_VERSION=$MYSQL_VERSION
LABEL MARIADB_VERSION=$MARIADB_VERSION
LABEL POSTGRESQL_VERSION=$POSTGRESQL_VERSION
LABEL JTDS_VERSION=$JTDS_VERSION

LABEL GIT_BRANCH=$GIT_BRANCH
LABEL GIT_REVISION=$GIT_REVISION

RUN mkdir /drivers_inc
WORKDIR /drivers_inc
RUN curl -JLO http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar
RUN curl -JLO http://search.maven.org/remotecontent?filepath=org/mariadb/jdbc/mariadb-java-client/$MARIADB_VERSION/mariadb-java-client-$MARIADB_VERSION.jar
RUN curl -JLO http://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/$POSTGRESQL_VERSION.jre7/postgresql-$POSTGRESQL_VERSION.jre7.jar
RUN curl -JLO http://search.maven.org/remotecontent?filepath=net/sourceforge/jtds/jtds/$JTDS_VERSION/jtds-$JTDS_VERSION.jar

RUN mkdir /download
WORKDIR /download
RUN curl -JLO https://github.com/schemaspy/schemaspy/releases/download/v${SCHEMASPY_VERSION}/schemaspy-${SCHEMASPY_VERSION}.jar

FROM openjdk:8u322-jre-slim-bullseye AS main

# RUN mkdir /usr/local/lib/schemaspy
COPY --from=download /download/schema*.jar /usr/local/lib/schemaspy/
COPY --from=download /drivers_inc /drivers_inc
COPY docker/schemaspy.sh /usr/local/bin/schemaspy


RUN useradd java && \
    apt-get update && \
    apt-get -y install --no-install-recommends unzip graphviz fonts-noto-cjk && \
    apt-get clean && \
    mkdir /output && \
    chown -R java /output

USER java
WORKDIR /

ENV SCHEMASPY_DRIVERS=/drivers
ENV SCHEMASPY_OUTPUT=/output

ENTRYPOINT ["/usr/local/bin/schemaspy"]

