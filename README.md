# docker-schemaspy
This repo has been forked from https://github.com/bateleurX/docker-schemaspy to allow schemaspy to run on macbooks with M1 processors.

see issue https://github.com/schemaspy/schemaspy/issues/793#issuecomment-1059673363

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

    DB=<db> docker-compose up --build
