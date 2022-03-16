target "mysql-nofont" {
    target = "mysql"
}

target "mariadb-nofont" {
    target = "mariadb"
}

target "postgresql-nofont" {
    target = "postgresql"
}

target "mysql-cjk" {
    target = "mysql-cjk"
}

target "mariadb-cjk" {
    target = "mariadb-cjk"
}

target "postgresql-cjk" {
    target = "postgresql-cjk"
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