package com.fitonyash.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.servers.Server;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
        info = @Info(
                title = "FitoNyash API",
                version = "1.0.0",
                description = "REST API для мобильного приложения доставки ПП еды FitoNyash",
                contact = @Contact(
                        name = "Никита Кочанов",
                        url = "https://github.com/bebrasa/Food-Delivery-App"
                ),
                license = @License(
                        name = "MIT License",
                        url = "https://opensource.org/licenses/MIT"
                )
        ),
        servers = {
                @Server(url = "http://localhost:8080", description = "Development server"),
                @Server(url = "https://api.fitonyash.ru", description = "Production server")
        }
)
@SecurityScheme(
        name = "bearerAuth",
        type = SecuritySchemeType.HTTP,
        scheme = "bearer",
        bearerFormat = "JWT",
        description = "JWT токен авторизации. Получите токен через /api/auth/login"
)
public class OpenApiConfig {
}

