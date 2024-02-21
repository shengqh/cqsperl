library("RSQLite")

con <- dbConnect(drv=RSQLite::SQLite(), dbname="/data/cqs/references/broad/funcotator/funcotator_dataSources.v1.8.hg19.20230908s.no_chr/cosmic/hg19/Cosmic.db")

tables <- dbListTables(con)
tables

df = dbGetQuery(conn=con, statement="SELECT * FROM Cosmic")
