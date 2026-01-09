package com.fitonyash.controller;

import com.fitonyash.dto.ApiResponse;
import com.fitonyash.dto.FoodItemDto;
import com.fitonyash.model.MenuType;
import com.fitonyash.model.User;
import com.fitonyash.service.FoodItemService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/food")
@RequiredArgsConstructor
@Tag(name = "Блюда", description = "API для работы с блюдами")
public class FoodItemController {

    private final FoodItemService foodItemService;

    @GetMapping
    @Operation(summary = "Получить все блюда")
    public ResponseEntity<ApiResponse<List<FoodItemDto>>> getAllFoodItems(
            @AuthenticationPrincipal User user
    ) {
        List<FoodItemDto> items = foodItemService.getAllFoodItems(user);
        return ResponseEntity.ok(ApiResponse.success(items));
    }

    @GetMapping("/paginated")
    @Operation(summary = "Получить блюда с пагинацией")
    public ResponseEntity<ApiResponse<Page<FoodItemDto>>> getFoodItemsPaginated(
            @PageableDefault(size = 20) Pageable pageable,
            @AuthenticationPrincipal User user
    ) {
        Page<FoodItemDto> items = foodItemService.getFoodItemsPaginated(pageable, user);
        return ResponseEntity.ok(ApiResponse.success(items));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Получить блюдо по ID")
    public ResponseEntity<ApiResponse<FoodItemDto>> getFoodItemById(
            @PathVariable Long id,
            @AuthenticationPrincipal User user
    ) {
        FoodItemDto item = foodItemService.getFoodItemById(id, user);
        return ResponseEntity.ok(ApiResponse.success(item));
    }

    @GetMapping("/category/{categoryId}")
    @Operation(summary = "Получить блюда по категории")
    public ResponseEntity<ApiResponse<List<FoodItemDto>>> getFoodItemsByCategory(
            @PathVariable Long categoryId,
            @AuthenticationPrincipal User user
    ) {
        List<FoodItemDto> items = foodItemService.getFoodItemsByCategory(categoryId, user);
        return ResponseEntity.ok(ApiResponse.success(items));
    }

    @GetMapping("/menu/{menuType}")
    @Operation(summary = "Получить блюда по типу меню")
    public ResponseEntity<ApiResponse<List<FoodItemDto>>> getFoodItemsByMenuType(
            @PathVariable MenuType menuType,
            @AuthenticationPrincipal User user
    ) {
        List<FoodItemDto> items = foodItemService.getFoodItemsByMenuType(menuType, user);
        return ResponseEntity.ok(ApiResponse.success(items));
    }

    @GetMapping("/popular")
    @Operation(summary = "Получить популярные блюда")
    public ResponseEntity<ApiResponse<List<FoodItemDto>>> getPopularFoodItems(
            @AuthenticationPrincipal User user
    ) {
        List<FoodItemDto> items = foodItemService.getPopularFoodItems(user);
        return ResponseEntity.ok(ApiResponse.success(items));
    }

    @GetMapping("/new")
    @Operation(summary = "Получить новинки")
    public ResponseEntity<ApiResponse<List<FoodItemDto>>> getNewFoodItems(
            @AuthenticationPrincipal User user
    ) {
        List<FoodItemDto> items = foodItemService.getNewFoodItems(user);
        return ResponseEntity.ok(ApiResponse.success(items));
    }

    @GetMapping("/search")
    @Operation(summary = "Поиск блюд")
    public ResponseEntity<ApiResponse<List<FoodItemDto>>> searchFoodItems(
            @RequestParam String query,
            @AuthenticationPrincipal User user
    ) {
        List<FoodItemDto> items = foodItemService.searchFoodItems(query, user);
        return ResponseEntity.ok(ApiResponse.success(items));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Создать новое блюдо (только для админа)")
    public ResponseEntity<ApiResponse<FoodItemDto>> createFoodItem(@RequestBody FoodItemDto dto) {
        FoodItemDto item = foodItemService.createFoodItem(dto);
        return ResponseEntity.ok(ApiResponse.success("Блюдо создано", item));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Обновить блюдо (только для админа)")
    public ResponseEntity<ApiResponse<FoodItemDto>> updateFoodItem(@PathVariable Long id, @RequestBody FoodItemDto dto) {
        FoodItemDto item = foodItemService.updateFoodItem(id, dto);
        return ResponseEntity.ok(ApiResponse.success("Блюдо обновлено", item));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Удалить блюдо (только для админа)")
    public ResponseEntity<ApiResponse<Void>> deleteFoodItem(@PathVariable Long id) {
        foodItemService.deleteFoodItem(id);
        return ResponseEntity.ok(ApiResponse.success("Блюдо удалено", null));
    }
}

