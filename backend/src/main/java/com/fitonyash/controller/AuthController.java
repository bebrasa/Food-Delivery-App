package com.fitonyash.controller;

import com.fitonyash.dto.ApiResponse;
import com.fitonyash.dto.auth.AuthResponse;
import com.fitonyash.dto.auth.LoginRequest;
import com.fitonyash.dto.auth.RefreshTokenRequest;
import com.fitonyash.dto.auth.RegisterRequest;
import com.fitonyash.model.User;
import com.fitonyash.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Tag(name = "Аутентификация", description = "API для регистрации и авторизации пользователей")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    @Operation(summary = "Регистрация нового пользователя")
    public ResponseEntity<ApiResponse<AuthResponse>> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse response = authService.register(request);
        return ResponseEntity.ok(ApiResponse.success("Регистрация успешна", response));
    }

    @PostMapping("/login")
    @Operation(summary = "Вход в систему")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success("Вход выполнен успешно", response));
    }

    @PostMapping("/refresh")
    @Operation(summary = "Обновление access токена")
    public ResponseEntity<ApiResponse<AuthResponse>> refreshToken(@Valid @RequestBody RefreshTokenRequest request) {
        AuthResponse response = authService.refreshToken(request);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/logout")
    @Operation(summary = "Выход из системы")
    public ResponseEntity<ApiResponse<Void>> logout(@AuthenticationPrincipal User user) {
        authService.logout(user.getId());
        return ResponseEntity.ok(ApiResponse.success("Выход выполнен успешно", null));
    }
}

