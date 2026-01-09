# Build stage
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage - используем образ с поддержкой ARM64
FROM eclipse-temurin:17-jre
WORKDIR /app

# Добавляем непривилегированного пользователя
RUN groupadd -r appgroup && useradd -r -g appgroup appuser

# Копируем JAR файл
COPY --from=build /app/target/*.jar app.jar

# Устанавливаем владельца
RUN chown -R appuser:appgroup /app

USER appuser

# Порт приложения
EXPOSE 8080

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/actuator/health || exit 1

# Запуск приложения
ENTRYPOINT ["java", "-jar", "app.jar"]
