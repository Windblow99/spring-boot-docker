# syntax=docker/dockerfile:1
#This always points to the latest release of the version 1 syntax. BuildKit automatically checks for updates of the syntax before building, making sure you are using the most current version.

# Next, we need to add a line in our Dockerfile that tells Docker what base image we would like to use for our application.
FROM openjdk:16-alpine3.13

# This instructs Docker to use this path as the default location for all subsequent commands. By doing this, we do not have to type out full file paths but can use relative paths based on the working directory.
WORKDIR /app

# Before we can run mvnw dependency, we need to get the Maven wrapper and our pom.xml file into our image. We’ll use the COPY command to do this. The COPY command takes two parameters. The first parameter tells Docker what file(s) you would like to copy into the image. The second parameter tells Docker where you want that file(s) to be copied to. We’ll copy all those files and directories into our working directory - /app.
COPY .mvn/ .mvn
COPY mvnw pom.xml ./

# Once we have our pom.xml file inside the image, we can use the RUN command to execute the command mvnw dependency:go-offline. This works exactly the same way as if we were running mvnw (or mvn) dependency locally on our machine, but this time the dependencies will be installed into the image.
RUN ./mvnw dependency:go-offline

# At this point, we have an Alpine version 3.13 image that is based on OpenJDK version 16, and we have also installed our dependencies. The next thing we need to do is to add our source code into the image. We’ll use the COPY command just like we did with our pom.xml file above.
COPY src ./src

# This COPY command takes all the files located in the current directory and copies them into the image. Now, all we have to do is to tell Docker what command we want to run when our image is executed inside a container. We do this using the CMD command.
CMD ["./mvnw", "spring-boot:run"]

# 