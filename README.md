# docker-schemaspy
schemaspy Dockerfile

create a file schemaspy

# type of database. Run with -dbhelp for details
schemaspy.t=psql11
# optional path to alternative jdbc drivers.
schemaspy.dp=path/to/drivers
# database properties: host, port number, name user, password
schemaspy.host=server
schemaspy.port=1433
schemaspy.db=db_name
schemaspy.u=database_user
schemaspy.p=database_password
# output dir to save generated files
schemaspy.o=path/to/output
# db scheme for which generate diagrams
schemaspy.s=dbo
