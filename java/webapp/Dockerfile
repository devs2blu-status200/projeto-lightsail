# Use official base image of Java Runtim
FROM adoptopenjdk/openjdk11

# Set the working directory in docker
WORKDIR /app

# Copy the jar to the working directory
COPY webapp-0.0.1-SNAPSHOT-plain.jar /app/webapp-0.0.1-SNAPSHOT-plain.jar

# Specify the entrypoint
ENTRYPOINT ["java", "-jar", "/app/webapp-0.0.1-SNAPSHOT-plain.jar"]
