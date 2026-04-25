# Confirm NgoThoai setup wrong maven/docker configuration
FROM eclipse-temurin:21-jre-alpine
COPY target/payment-paypal*.jar app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]