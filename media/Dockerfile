# Trigger CI job to build image
FROM eclipse-temurin:21-jre-alpine
COPY target/media*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]