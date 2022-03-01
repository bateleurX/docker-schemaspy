# docker-schem(aspy
Modified version of [SchemaSpy](https://schemaspy.org/) Dockerfile.

# Difference from original Dockerfile
- JDK: 8u111 -> 8u322
- Distribution: alpine -> Debian
- MySQL Connector/J: 6.0.6 -> 8.0.28
- MariaDB Connector/J: 1.1.10 -> 1.1.10
- PostgreSQL JDBC Driver: 42.1.1 -> 42.2.5
- Added linux/arm64 architecture(works at m1 mac)
