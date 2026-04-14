# Use for testing with `docker build -t cart:latest .`
FROM eclipse-temurin:25-jre-alpine
COPY target/cart*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]