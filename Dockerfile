ARG GIT_BRANCH=local
ARG GIT_REVISION=local

ARG SCHEMASPY_VERSION=6.1.0
ARG MYSQL_VERSION=8.0.28
ARG MARIADB_VERSION=3.0.3
ARG POSTGRESQL_VERSION=42.3.3

# Download files
FROM curlimages/curl:latest AS download-mysql

ENV LC_ALL=C

ARG GIT_BRANCH
ARG GIT_REVISION

ARG MYSQL_VERSION

ENV MYSQL_VERSION=$MYSQL_VERSION

RUN mkdir -p /tmp/drivers_inc
WORKDIR /tmp/drivers_inc
RUN curl -JLO https://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/$MYSQL_VERSION/mysql-connector-java-$MYSQL_VERSION.jar

FROM curlimages/curl:latest AS download-mariadb

ENV LC_ALL=C

ARG GIT_BRANCH
ARG GIT_REVISION

ARG MARIADB_VERSION

ENV MARIADB_VERSION=$MARIADB_VERSION

RUN mkdir -p /tmp/drivers_inc
WORKDIR /tmp/drivers_inc
RUN curl -JLO https://search.maven.org/remotecontent?filepath=org/mariadb/jdbc/mariadb-java-client/$MARIADB_VERSION/mariadb-java-client-$MARIADB_VERSION.jar

FROM curlimages/curl:latest AS download-postgresql

ENV LC_ALL=C

ARG GIT_BRANCH
ARG GIT_REVISION

ARG POSTGRESQL_VERSION

ENV POSTGRESQL_VERSION=$POSTGRESQL_VERSION

RUN mkdir -p /tmp/drivers_inc
WORKDIR /tmp/drivers_inc
RUN curl -JLO https://search.maven.org/remotecontent?filepath=org/postgresql/postgresql/$POSTGRESQL_VERSION/postgresql-$POSTGRESQL_VERSION.jar

FROM curlimages/curl:latest AS download-schemaspy

ENV LC_ALL=C

ARG GIT_BRANCH
ARG GIT_REVISION

ARG SCHEMASPY_VERSION

ENV SCHEMASPY_VERSION=$SCHEMASPY_VERSION

RUN mkdir -p /tmp/download
WORKDIR /tmp/download
RUN curl -JLO https://github.com/schemaspy/schemaspy/releases/download/v${SCHEMASPY_VERSION}/schemaspy-${SCHEMASPY_VERSION}.jar

# Build images
FROM openjdk:8u332-jre-slim-bullseye AS mysql

ARG GIT_BRANCH
ARG GIT_REVISION

ARG SCHEMASPY_VERSION
ARG MYSQL_VERSION

ENV SCHEMASPY_VERSION=$SCHEMASPY_VERSION
ENV MYSQL_VERSION=$MYSQL_VERSION

LABEL MYSQL_VERSION=$MYSQL_VERSION

LABEL GIT_BRANCH=$GIT_BRANCH
LABEL GIT_REVISION=$GIT_REVISION

COPY --from=download-schemaspy /tmp/download/schema*.jar /usr/local/lib/schemaspy/
COPY --from=download-mysql /tmp/drivers_inc /drivers_inc
COPY docker/schemaspy.sh /usr/local/bin/schemaspy

RUN useradd java && \
    apt-get update && \
    apt-get -y install --no-install-recommends unzip graphviz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /output && \
    chown -R java /output

USER java
WORKDIR /

ENV SCHEMASPY_DRIVERS=/drivers
ENV SCHEMASPY_OUTPUT=/output

ENTRYPOINT ["/usr/local/bin/schemaspy"]

FROM openjdk:8u332-jre-slim-bullseye AS mariadb

ARG GIT_BRANCH
ARG GIT_REVISION

ARG SCHEMASPY_VERSION
ARG MARIADB_VERSION

ENV SCHEMASPY_VERSION=$SCHEMASPY_VERSION
ENV MARIADB_VERSION=$MARIADB_VERSION

LABEL MARIADB_VERSION=$MARIADB_VERSION

LABEL GIT_BRANCH=$GIT_BRANCH
LABEL GIT_REVISION=$GIT_REVISION

COPY --from=download-schemaspy /tmp/download/schema*.jar /usr/local/lib/schemaspy/
COPY --from=download-mariadb /tmp/drivers_inc /drivers_inc
COPY docker/schemaspy.sh /usr/local/bin/schemaspy

RUN useradd java && \
    apt-get update && \
    apt-get -y install --no-install-recommends unzip graphviz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /output && \
    chown -R java /output

USER java
WORKDIR /

ENV SCHEMASPY_DRIVERS=/drivers
ENV SCHEMASPY_OUTPUT=/output

ENTRYPOINT ["/usr/local/bin/schemaspy"]

FROM openjdk:8u332-jre-slim-bullseye AS postgresql

ARG GIT_BRANCH
ARG GIT_REVISION

ARG SCHEMASPY_VERSION
ARG POSTGRESQL_VERSION

ENV SCHEMASPY_VERSION=$SCHEMASPY_VERSION
ENV POSTGRESQL_VERSION=$POSTGRESQL_VERSION

LABEL POSTGRESQL_VERSION=$POSTGRESQL_VERSION

LABEL GIT_BRANCH=$GIT_BRANCH
LABEL GIT_REVISION=$GIT_REVISION

COPY --from=download-schemaspy /tmp/download/schema*.jar /usr/local/lib/schemaspy/
COPY --from=download-postgresql /tmp/drivers_inc /drivers_inc
COPY docker/schemaspy.sh /usr/local/bin/schemaspy

RUN useradd java && \
    apt-get update && \
    apt-get -y install --no-install-recommends unzip graphviz && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /output && \
    chown -R java /output

USER java
WORKDIR /

ENV SCHEMASPY_DRIVERS=/drivers
ENV SCHEMASPY_OUTPUT=/output

ENTRYPOINT ["/usr/local/bin/schemaspy"]

FROM openjdk:8u332-jre-slim-bullseye AS mysql-cjk

ARG GIT_BRANCH
ARG GIT_REVISION

ARG SCHEMASPY_VERSION
ARG MYSQL_VERSION

ENV SCHEMASPY_VERSION=$SCHEMASPY_VERSION
ENV MYSQL_VERSION=$MYSQL_VERSION

LABEL MYSQL_VERSION=$MYSQL_VERSION

LABEL GIT_BRANCH=$GIT_BRANCH
LABEL GIT_REVISION=$GIT_REVISION

COPY --from=download-schemaspy /tmp/download/schema*.jar /usr/local/lib/schemaspy/
COPY --from=download-mysql /tmp/drivers_inc /drivers_inc
COPY docker/schemaspy.sh /usr/local/bin/schemaspy

RUN useradd java && \
    apt-get update && \
    apt-get -y install --no-install-recommends unzip graphviz fonts-noto-cjk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /output && \
    chown -R java /output

USER java
WORKDIR /

ENV SCHEMASPY_DRIVERS=/drivers
ENV SCHEMASPY_OUTPUT=/output

ENTRYPOINT ["/usr/local/bin/schemaspy"]

FROM openjdk:8u332-jre-slim-bullseye AS mariadb-cjk

ARG GIT_BRANCH
ARG GIT_REVISION

ARG SCHEMASPY_VERSION
ARG MARIADB_VERSION

ENV SCHEMASPY_VERSION=$SCHEMASPY_VERSION
ENV MARIADB_VERSION=$MARIADB_VERSION

LABEL MARIADB_VERSION=$MARIADB_VERSION

LABEL GIT_BRANCH=$GIT_BRANCH
LABEL GIT_REVISION=$GIT_REVISION

COPY --from=download-schemaspy /tmp/download/schema*.jar /usr/local/lib/schemaspy/
COPY --from=download-mariadb /tmp/drivers_inc /drivers_inc
COPY docker/schemaspy.sh /usr/local/bin/schemaspy

RUN useradd java && \
    apt-get update && \
    apt-get -y install --no-install-recommends unzip graphviz fonts-noto-cjk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /output && \
    chown -R java /output

USER java
WORKDIR /

ENV SCHEMASPY_DRIVERS=/drivers
ENV SCHEMASPY_OUTPUT=/output

ENTRYPOINT ["/usr/local/bin/schemaspy"]

FROM openjdk:8u332-jre-slim-bullseye AS postgresql-cjk

ARG GIT_BRANCH
ARG GIT_REVISION

ARG SCHEMASPY_VERSION
ARG POSTGRESQL_VERSION

ENV SCHEMASPY_VERSION=$SCHEMASPY_VERSION
ENV POSTGRESQL_VERSION=$POSTGRESQL_VERSION

LABEL POSTGRESQL_VERSION=$POSTGRESQL_VERSION

LABEL GIT_BRANCH=$GIT_BRANCH
LABEL GIT_REVISION=$GIT_REVISION

COPY --from=download-schemaspy /tmp/download/schema*.jar /usr/local/lib/schemaspy/
COPY --from=download-postgresql /tmp/drivers_inc /drivers_inc
COPY docker/schemaspy.sh /usr/local/bin/schemaspy

RUN useradd java && \
    apt-get update && \
    apt-get -y install --no-install-recommends unzip graphviz fonts-noto-cjk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /output && \
    chown -R java /output

USER java
WORKDIR /

ENV SCHEMASPY_DRIVERS=/drivers
ENV SCHEMASPY_OUTPUT=/output

ENTRYPOINT ["/usr/local/bin/schemaspy"]
