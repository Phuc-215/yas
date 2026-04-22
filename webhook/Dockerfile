# Use an official OpenJDK runtime as a parent image
# Trigger CI job to build image
FROM eclipse-temurin:21-jre-alpine
COPY target/webhook*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]