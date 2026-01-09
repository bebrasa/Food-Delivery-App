package com.fitonyash.controller;

import com.fitonyash.dto.ApiResponse;
import com.fitonyash.dto.UpdateProfileRequest;
import com.fitonyash.dto.UserProfileDto;
import com.fitonyash.model.User;
import com.fitonyash.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/user")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Профиль", description = "API для работы с профилем пользователя")
public class UserController {

    private final UserService userService;

    @GetMapping("/profile")
    @Operation(summary = "Получить профиль")
    public ResponseEntity<ApiResponse<UserProfileDto>> getProfile(@AuthenticationPrincipal User user) {
        UserProfileDto profile = userService.getProfile(user);
        return ResponseEntity.ok(ApiResponse.success(profile));
    }

    @PutMapping("/profile")
    @Operation(summary = "Обновить профиль")
    public ResponseEntity<ApiResponse<UserProfileDto>> updateProfile(
            @AuthenticationPrincipal User user,
            @RequestBody UpdateProfileRequest request
    ) {
        UserProfileDto profile = userService.updateProfile(user, request);
        return ResponseEntity.ok(ApiResponse.success("Профиль обновлен", profile));
    }

    @PostMapping("/change-password")
    @Operation(summary = "Сменить пароль")
    public ResponseEntity<ApiResponse<Void>> changePassword(
            @AuthenticationPrincipal User user,
            @RequestParam String oldPassword,
            @RequestParam String newPassword
    ) {
        userService.changePassword(user, oldPassword, newPassword);
        return ResponseEntity.ok(ApiResponse.success("Пароль изменен", null));
    }
}

