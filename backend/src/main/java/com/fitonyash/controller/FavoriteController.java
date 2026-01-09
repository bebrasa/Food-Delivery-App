package com.fitonyash.controller;

import com.fitonyash.dto.ApiResponse;
import com.fitonyash.dto.FoodItemDto;
import com.fitonyash.model.User;
import com.fitonyash.service.FavoriteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Избранное", description = "API для работы с избранными блюдами")
public class FavoriteController {

    private final FavoriteService favoriteService;

    @GetMapping
    @Operation(summary = "Получить список избранного")
    public ResponseEntity<ApiResponse<List<FoodItemDto>>> getFavorites(@AuthenticationPrincipal User user) {
        List<FoodItemDto> favorites = favoriteService.getFavorites(user);
        return ResponseEntity.ok(ApiResponse.success(favorites));
    }

    @PostMapping("/{foodItemId}")
    @Operation(summary = "Добавить блюдо в избранное")
    public ResponseEntity<ApiResponse<FoodItemDto>> addToFavorites(
            @AuthenticationPrincipal User user,
            @PathVariable Long foodItemId
    ) {
        FoodItemDto item = favoriteService.addToFavorites(user, foodItemId);
        return ResponseEntity.ok(ApiResponse.success("Добавлено в избранное", item));
    }

    @DeleteMapping("/{foodItemId}")
    @Operation(summary = "Удалить блюдо из избранного")
    public ResponseEntity<ApiResponse<Void>> removeFromFavorites(
            @AuthenticationPrincipal User user,
            @PathVariable Long foodItemId
    ) {
        favoriteService.removeFromFavorites(user, foodItemId);
        return ResponseEntity.ok(ApiResponse.success("Удалено из избранного", null));
    }

    @PostMapping("/toggle/{foodItemId}")
    @Operation(summary = "Переключить статус избранного")
    public ResponseEntity<ApiResponse<FoodItemDto>> toggleFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable Long foodItemId
    ) {
        FoodItemDto item = favoriteService.toggleFavorite(user, foodItemId);
        String message = item.getIsFavorite() ? "Добавлено в избранное" : "Удалено из избранного";
        return ResponseEntity.ok(ApiResponse.success(message, item));
    }

    @GetMapping("/check/{foodItemId}")
    @Operation(summary = "Проверить, находится ли блюдо в избранном")
    public ResponseEntity<ApiResponse<Boolean>> isFavorite(
            @AuthenticationPrincipal User user,
            @PathVariable Long foodItemId
    ) {
        boolean isFavorite = favoriteService.isFavorite(user, foodItemId);
        return ResponseEntity.ok(ApiResponse.success(isFavorite));
    }
}

