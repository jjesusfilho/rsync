context("loadData")
expectTrue <- function(a) testthat::expect_true(a)

dirName <- tempdir()
try(file.remove(paste0(dirName,'/extraFolder')), silent = TRUE)
dirName2 <- paste0(dirName, '/extraFolder/')
dir.create(dirName2)
# In case we run these Tests multiple times in a row:
file.remove(dir(dirName2, "Rdata|csv|json", full.names = TRUE))
file.remove(dir(dirName, "Rdata|csv|json", full.names = TRUE))

#Rdata
x <- 1
y <- 2
save(list = "x", file = paste0(dirName, "/", "x.Rdata"))
save(list = "y", file = paste0(dirName, "/", "y.Rdata"))

#csv
dat <- data.frame(
  x = 1L,
  date = "2018-12-24",
  z = 1.12345,
  stringsAsFactors = FALSE
)

data.table::fwrite(dat, file = paste0(dirName, "/", "x.csv"))

#json
lst <- list(
  x = 1:3,
  date = "2018-12-24"
)
jsonlite::write_json(lst, path = paste0(dirName, "/", "lst.json"))

serverTestingRsyncL <- newRsync(from = dirName,
                                to = dirName2)


nameServer <- NULL
suppressWarnings(try(source("~/.inwt/rsync/config.R"), silent=TRUE))
if(!is.null(nameServer)){
  test_that("rdata for rsyncD can be loaded", {

    serverTestingRsyncD <- newRsync(from = dirName,
                                    host = hostURL,
                                    name = nameServer,
                                    password = passwordServer)
    # rsyncD
    #Rdata
    invisible(deleteAllEntries(db = serverTestingRsyncD))
    invisible(sendFile(db = serverTestingRsyncD, fileName = 'x.Rdata'))
    expectTrue(nrow(listEntries(serverTestingRsyncD)) == 1)
    rdata <- loadData(db = serverTestingRsyncD, dataName = 'x.Rdata')
    expectTrue(!is.null(objects(rdata)))
    rm(rdata)
    expectTrue(file.exists(paste0(dirName, '/','x.Rdata')))
    invisible(deleteAllEntries(db = serverTestingRsyncD))

    #csv
    invisible(deleteAllEntries(db = serverTestingRsyncD))
    invisible(sendFile(db = serverTestingRsyncD, fileName = 'x.csv'))
    expectTrue(nrow(listEntries(serverTestingRsyncD)) == 1)
    csvData <- loadData(db = serverTestingRsyncD, dataName = 'x.csv')
    expectTrue(!is.null(objects(csvData)))
    expectTrue(file.exists(paste0(dirName, '/','x.csv')))
    invisible(deleteAllEntries(db = serverTestingRsyncD))

    #json
    invisible(deleteAllEntries(db = serverTestingRsyncD))
    invisible(sendFile(db = serverTestingRsyncD, fileName = 'lst.json'))
    expectTrue(nrow(listEntries(serverTestingRsyncD)) == 1)
    jsonData <- loadData(db = serverTestingRsyncD, dataName = 'lst.json')
    expectTrue(!is.null(objects(jsonData)))
    rm(jsonData)
    expectTrue(file.exists(paste0(dirName, '/','lst.json')))
    invisible(deleteAllEntries(db = serverTestingRsyncD))
  })
}

test_that("rdata for rsyncL can be loaded", {

  #rsyncL
  #rdata
  invisible(deleteAllEntries(db = serverTestingRsyncL))
  invisible(sendFile(db = serverTestingRsyncL, fileName = 'x.Rdata'))
  expectTrue(nrow(listEntries(serverTestingRsyncL)) == 1)
  file.remove(paste0(dirName, '/','x.Rdata'))

  rdata <- loadData(db = serverTestingRsyncL, dataName = 'x.Rdata')
  expectTrue(!is.null(objects(rdata)))
  expectTrue(file.exists(paste0(dirName, '/','x.Rdata')))
  invisible(deleteAllEntries(db = serverTestingRsyncL))
  rm(rdata)

  #csv
  invisible(deleteAllEntries(db = serverTestingRsyncL))
  invisible(sendFile(db = serverTestingRsyncL, fileName = 'x.csv'))
  expectTrue(nrow(listEntries(serverTestingRsyncL)) == 1)
  csvData <- loadData(db = serverTestingRsyncL, dataName = 'x.csv')
  expectTrue(!is.null(objects(csvData)))
  expectTrue(file.exists(paste0(dirName, '/','x.csv')))
  invisible(deleteAllEntries(db = serverTestingRsyncL))

  #json
  invisible(deleteAllEntries(db = serverTestingRsyncL))
  invisible(sendFile(db = serverTestingRsyncL, fileName = 'lst.json'))
  expectTrue(nrow(listEntries(serverTestingRsyncL)) == 1)
  jsonData <- loadData(db = serverTestingRsyncL, dataName = 'lst.json')
  expectTrue(!is.null(objects(jsonData)))
  rm(jsonData)
  expectTrue(file.exists(paste0(dirName, '/','lst.json')))
  invisible(deleteAllEntries(db = serverTestingRsyncL))

  # #remove traces for further tests
  # file.remove(dir(dirName2, "Rdata|csv|json", full.names = TRUE))
  # file.remove(dir(dirName, "Rdata|csv|json", full.names = TRUE))
})


