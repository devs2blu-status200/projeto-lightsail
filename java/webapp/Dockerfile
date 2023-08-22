# Use official base image of Java Runtim
FROM adoptopenjdk:11-jre-hotspot

# Set the working directory in docker
WORKDIR /app

# Copy the jar to the working directory
COPY build/libs/my-web-app-0.0.1-SNAPSHOT.jar /app/my-web-app.jar

# Specify the entrypoint
ENTRYPOINT ["java", "-jar", "/app/my-web-app.jar"]
