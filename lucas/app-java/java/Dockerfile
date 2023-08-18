# 1st estágio - Buildando o arquivo JAR
FROM maven:3.8.2-jdk-8 AS build

WORKDIR /app
COPY . .
RUN mvn clean package

# 2nd estágio - Criando a imagem final
FROM eclipse-temurin:latest

COPY --from=build /app/target/java-1.0-SNAPSHOT.jar /app/java-1.0-SNAPSHOT.jar

WORKDIR /app

ENTRYPOINT ["java", "-jar", "java-1.0-SNAPSHOT.jar"]
