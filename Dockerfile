# Use an official OpenJDK 17 image as the base image
FROM openjdk:17-jre-slim

# Copy your Spring Boot jar into the container
COPY target/aks-demo-0.0.1-SNAPSHOT.jar /usr/app/

# Set the working directory
WORKDIR /usr/app

# Expose the port that your Spring Boot app will run on
EXPOSE 8080

# Command to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "aks-demo-0.0.1-SNAPSHOT.jar"]
