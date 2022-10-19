variable "PREFIX" {
    default = "docker.io"
}

target "base" {
    dockerfile = "Dockerfile-temurin"
    platforms = ["linux/amd64", "linux/arm64"]
}

target "mysql-nofont" {
    inherits = ["base"]
    target = "mysql"
    tags = ["${PREFIX}/schemaspy:6.1.1-SNAPSHOT-temurin-mysql"]
}

target "mariadb-nofont" {
    inherits = ["base"]
    target = "mariadb"
    tags = ["${PREFIX}/schemaspy:6.1.1-SNAPSHOT-temurin-mariadb"]
}

target "postgresql-nofont" {
    inherits = ["base"]
    target = "postgresql"
    tags = ["${PREFIX}/schemaspy:6.1.1-SNAPSHOT-temurin-postgresql"]
}

target "mysql-cjk" {
    inherits = ["base"]
    target = "mysql-cjk"
    tags = ["${PREFIX}/schemaspy:6.1.1-SNAPSHOT-temurin-mysql-cjk"]
}

target "mariadb-cjk" {
    inherits = ["base"]
    target = "mariadb-cjk"
    tags = ["${PREFIX}/schemaspy:6.1.1-SNAPSHOT-temurin-mariadb-cjk"]
}

target "postgresql-cjk" {
    inherits = ["base"]
    target = "postgresql-cjk"
    tags = ["${PREFIX}/schemaspy:6.1.1-SNAPSHOT-temurin-postgresql-cjk"]
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