

y <- Sys.getenv("PATH")
x <- paste0(y,";","C:\\Rtools\\bin;C:\\Rtools\\gcc-4.6.3\\bin", ";",
            "C:\\RBuildTools\\3.4",";","C:\\RBuildTools\\3.4\\bin")
Sys.setenv(PATH=x)

