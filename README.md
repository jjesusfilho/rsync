## RSync-Package of INWT

In this project we provide functionalites of Rsync for INWT project.


## Why using Rsync:

Rsync is a tool, which is used with Unix systems and allows efficient transferring and synchronizing of files across computer systems. 


## How to use Rsync:

The Rsync functionality can be used in two ways: 
1) directely transferring / synchronizing files or 
2) using Rsync in combination with a server

Use the `rsync`function in the following way: 

```
rsync(from = "SyncTest/Testfile1.R", to = "SyncDestination/")
```

In order to use RSync with a server, credentials must be stored in the home directory under the folder `.rsync` and the file name `rsync.yaml`.
The `rsync.yaml` file needs to have the following structure:

```
hostURL: "rsync://example-url-of-host.de"
nameServer: "exampleServerName"
passwordServer:  "examplePassword1234"
urlServer: "https://url-to-Server.de"
```








