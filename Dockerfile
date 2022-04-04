ARG GIT_BRANCH=local
ARG GIT_REVISION=local

ARG SCHEMASPY_VERSION=6.1.0
ARG MYSQL_VERSION=6.0.6
ARG MARIADB_VERSION=1.1.10
ARG POSTGRESQL_VERSION=42.1.1
ARG JTDS_VERSION=1.3.1

FROM curlimages/curl:latest AS download

ENV LC_ALL=C

ARG GIT_BRANCH
ARG GIT_REVISION

ARG SCHEMASPY_VERSION
ARG MYSQL_VERSION
ARG MARIADB_VERSION
ARG POSTGRESQL_VERSION
ARG JTDS_VERSION

ENV SCHEMASPY_VERSION=$SCHEMASPY_VERSION
ENV MYSQL_VERSION=$MYSQL_VERSION
ENV MARIADB_VERSION=$MARIADB_VERSION
ENV POSTGRESQL_VERSION=$POSTGRESQL_VERSION
ENV JTDS_VERSION=$JTDS_VERSION

RUN mkdir -p /tmp/drivers_inc
WORKDIR /tmp/drivers_inc
RUN curl -JLO http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar && \
    curl -JLO http://search.maven.org/remotecontent?filepath=org/mariadb/jdbc/mariadb-java-client/$MARIADB_VERSION/mariadb-java-client-$MARIADB_VERSION.jar && \
    curl -JLO http://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/$POSTGRESQL_VERSION.jre7/postgresql-$POSTGRESQL_VERSION.jre7.jar && \
    curl -JLO http://search.maven.org/remotecontent?filepath=net/sourceforge/jtds/jtds/$JTDS_VERSION/jtds-$JTDS_VERSION.jar

RUN mkdir -p /tmp/download
WORKDIR /tmp/download
RUN curl -JLO https://github.com/schemaspy/schemaspy/releases/download/v${SCHEMASPY_VERSION}/schemaspy-${SCHEMASPY_VERSION}.jar

FROM openjdk:8u322-jre-slim-bullseye AS main

ARG GIT_BRANCH
ARG GIT_REVISION

ARG SCHEMASPY_VERSION
ARG MYSQL_VERSION
ARG MARIADB_VERSION
ARG POSTGRESQL_VERSION
ARG JTDS_VERSION

ENV SCHEMASPY_VERSION=$SCHEMASPY_VERSION
ENV MYSQL_VERSION=$MYSQL_VERSION
ENV MARIADB_VERSION=$MARIADB_VERSION
ENV POSTGRESQL_VERSION=$POSTGRESQL_VERSION
ENV JTDS_VERSION=$JTDS_VERSION

LABEL MYSQL_VERSION=$MYSQL_VERSION
LABEL MARIADB_VERSION=$MARIADB_VERSION
LABEL POSTGRESQL_VERSION=$POSTGRESQL_VERSION
LABEL JTDS_VERSION=$JTDS_VERSION

LABEL GIT_BRANCH=$GIT_BRANCH
LABEL GIT_REVISION=$GIT_REVISION

COPY --from=download /tmp/download/schema*.jar /usr/local/lib/schemaspy/
COPY --from=download /tmp/drivers_inc /drivers_inc
COPY ./docker/schemaspy.sh /usr/local/bin/schemaspy

# TODO: Install the AWS CLI 

RUN useradd java && \
    apt-get update && \
    apt-get -y install --no-install-recommends unzip graphviz curl jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    mkdir /output && \
    chown -R java /output

USER java
WORKDIR /

ENV SCHEMASPY_DRIVERS=/drivers

# THESE WILL ALL BE OVERRIDDEN AT RUNTIME
ENV DB_TYPE='pgsql11' \
    DB_HOST='' \
    DB_PORT=5432 \
    DB_USER='' \
    DB_PASSWORD=''

RUN echo "SMOKE TESTS:" && \
    aws --version

ENTRYPOINT [ "/usr/local/bin/schemaspy" ]
CMD ["-t $DB_TYPE","-host $DB_HOST","-port $DB_PORT","-u $DB_USER","-p $DB_PASSWORD"]
