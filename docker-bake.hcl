target "base" {
    platforms = ["linux/amd64", "linux/arm64"]
}

target "mysql-nofont" {
    inherits = ["base"]
    target = "mysql"
    tags = ["schemaspy-6.1.0-mysql"]
}

target "mariadb-nofont" {
    inherits = ["base"]
    target = "mariadb"
    tags = ["schemaspy-6.1.0-mariadb"]
}

target "postgresql-nofont" {
    inherits = ["base"]
    target = "postgresql"
    tags = ["schemaspy-6.1.0-postgresql"]
}

target "mysql-cjk" {
    inherits = ["base"]
    target = "mysql-cjk"
    tags = ["schemaspy-6.1.0-mysql-cjk"]
}

target "mariadb-cjk" {
    inherits = ["base"]
    target = "mariadb-cjk"
    tags = ["schemaspy-6.1.0-mariadb-cjk"]
}

target "postgresql-cjk" {
    inherits = ["base"]
    target = "postgresql-cjk"
    tags = ["schemaspy-6.1.0-postgresql-cjk"]
}

group "mysql" {
    targets = ["mysql-nofont", "mysql-cjk"]
}

group "mariadb" {
    targets = ["mariadb-nofont", "mariadb-cjk"]
}

group "postgresql" {
    targets = ["postgresql-nofont", "postgresql-cjk"]
}

group "default" {
    targets = ["mysql", "mariadb", "postgresql"]
}