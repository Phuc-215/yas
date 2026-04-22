# Trigger CI job to build image
FROM eclipse-temurin:21-jre-alpine
COPY target/customer*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]