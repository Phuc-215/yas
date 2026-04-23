# Trigger CI job to rebuild image
FROM eclipse-temurin:21-jre-alpine
COPY target/inventory*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]