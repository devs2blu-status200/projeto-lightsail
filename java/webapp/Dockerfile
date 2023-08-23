# Use official base image of Java Runtim
FROM adoptopenjdk/openjdk11

# Set the working directory in docker
WORKDIR /app

# Copy the jar to the working directory
COPY build/libs/webapp-0.0.1-SNAPSHOT.jar /app/webapp-0.0.1-SNAPSHOT.jar

# Specify the entrypoint
ENTRYPOINT ["java", "-jar", "/app/webapp-0.0.1-SNAPSHOT.jar"]
