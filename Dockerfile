# ── Stage 1: Build ────────────────────────────────────────────────
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy root pom.xml
COPY pom.xml .

# Copy pom.xml của tất cả modules để cache dependencies
COPY common-library/pom.xml        common-library/pom.xml
COPY backoffice-bff/pom.xml        backoffice-bff/pom.xml
COPY cart/pom.xml                  cart/pom.xml
COPY customer/pom.xml              customer/pom.xml
COPY inventory/pom.xml             inventory/pom.xml
COPY location/pom.xml              location/pom.xml
COPY media/pom.xml                 media/pom.xml
COPY order/pom.xml                 order/pom.xml
COPY payment-paypal/pom.xml        payment-paypal/pom.xml
COPY payment/pom.xml               payment/pom.xml
COPY product/pom.xml               product/pom.xml
COPY promotion/pom.xml             promotion/pom.xml
COPY rating/pom.xml                rating/pom.xml
COPY search/pom.xml                search/pom.xml
COPY storefront-bff/pom.xml        storefront-bff/pom.xml
COPY tax/pom.xml                   tax/pom.xml
COPY webhook/pom.xml               webhook/pom.xml
COPY sampledata/pom.xml            sampledata/pom.xml
COPY recommendation/pom.xml        recommendation/pom.xml
COPY delivery/pom.xml              delivery/pom.xml

# Download tất cả dependencies trước → tận dụng Docker layer cache
# Bước này chỉ re-run khi có pom.xml thay đổi
RUN mvn dependency:go-offline -B

# Copy toàn bộ source code
COPY . .

# SERVICE được truyền vào lúc docker build
# Ví dụ: --build-arg SERVICE=cart
ARG SERVICE

# Build service chỉ định + các module nó phụ thuộc (-am)
RUN mvn -pl ${SERVICE} -am clean package -DskipTests -B

# ── Stage 2: Runtime ──────────────────────────────────────────────
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

ARG SERVICE

COPY --from=builder /app/${SERVICE}/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
