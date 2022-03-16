# docker-schemaspy

## Getting started

before building image create a file schemaspy.properties at the root ofdirectory

    # type of database. use pgsql11 for posgres
    schemaspy.t=<db type>
    # database properties: host, port number, name user, password
    schemaspy.host=<host>
    schemaspy.port=<port>
    schemaspy.db=<db>
    schemaspy.u=<user>
    schemaspy.p=<password>


Run

    docker-compose up --build
