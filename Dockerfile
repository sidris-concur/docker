FROM openjdk:8-jre-alpine

MAINTAINER simon.idris@concur.com

WORKDIR /app

# Copy over and extract tar distribution
ADD ./build/libs/helloworld-0.1.0.jar /app

# Make port 8080 available
EXPOSE 8080

# Define environment variable
ENV NAME Docker

# Command to start service
CMD ["java", "-jar", "helloworld-0.1.0.jar"]