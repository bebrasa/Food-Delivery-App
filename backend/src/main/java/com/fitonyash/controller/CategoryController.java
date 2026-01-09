package com.fitonyash.controller;

import com.fitonyash.dto.ApiResponse;
import com.fitonyash.dto.CategoryDto;
import com.fitonyash.service.CategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
@Tag(name = "Категории", description = "API для работы с категориями блюд")
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping
    @Operation(summary = "Получить все категории")
    public ResponseEntity<ApiResponse<List<CategoryDto>>> getAllCategories() {
        List<CategoryDto> categories = categoryService.getAllCategories();
        return ResponseEntity.ok(ApiResponse.success(categories));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Получить категорию по ID")
    public ResponseEntity<ApiResponse<CategoryDto>> getCategoryById(@PathVariable Long id) {
        CategoryDto category = categoryService.getCategoryById(id);
        return ResponseEntity.ok(ApiResponse.success(category));
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Создать новую категорию (только для админа)")
    public ResponseEntity<ApiResponse<CategoryDto>> createCategory(@RequestBody CategoryDto dto) {
        CategoryDto category = categoryService.createCategory(dto);
        return ResponseEntity.ok(ApiResponse.success("Категория создана", category));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Обновить категорию (только для админа)")
    public ResponseEntity<ApiResponse<CategoryDto>> updateCategory(@PathVariable Long id, @RequestBody CategoryDto dto) {
        CategoryDto category = categoryService.updateCategory(id, dto);
        return ResponseEntity.ok(ApiResponse.success("Категория обновлена", category));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    @SecurityRequirement(name = "bearerAuth")
    @Operation(summary = "Удалить категорию (только для админа)")
    public ResponseEntity<ApiResponse<Void>> deleteCategory(@PathVariable Long id) {
        categoryService.deleteCategory(id);
        return ResponseEntity.ok(ApiResponse.success("Категория удалена", null));
    }
}

