package com.fitonyash.controller;

import com.fitonyash.dto.ApiResponse;
import com.fitonyash.dto.CartDto;
import com.fitonyash.model.User;
import com.fitonyash.service.CartService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Корзина", description = "API для работы с корзиной")
public class CartController {

    private final CartService cartService;

    @GetMapping
    @Operation(summary = "Получить корзину")
    public ResponseEntity<ApiResponse<CartDto>> getCart(@AuthenticationPrincipal User user) {
        CartDto cart = cartService.getCart(user);
        return ResponseEntity.ok(ApiResponse.success(cart));
    }

    @PostMapping("/add/{foodItemId}")
    @Operation(summary = "Добавить товар в корзину")
    public ResponseEntity<ApiResponse<CartDto>> addToCart(
            @AuthenticationPrincipal User user,
            @PathVariable Long foodItemId,
            @RequestParam(required = false, defaultValue = "1") Integer quantity
    ) {
        CartDto cart = cartService.addToCart(user, foodItemId, quantity);
        return ResponseEntity.ok(ApiResponse.success("Товар добавлен в корзину", cart));
    }

    @PutMapping("/update/{foodItemId}")
    @Operation(summary = "Обновить количество товара в корзине")
    public ResponseEntity<ApiResponse<CartDto>> updateCartItemQuantity(
            @AuthenticationPrincipal User user,
            @PathVariable Long foodItemId,
            @RequestParam Integer quantity
    ) {
        CartDto cart = cartService.updateCartItemQuantity(user, foodItemId, quantity);
        return ResponseEntity.ok(ApiResponse.success("Количество обновлено", cart));
    }

    @DeleteMapping("/remove/{foodItemId}")
    @Operation(summary = "Удалить товар из корзины")
    public ResponseEntity<ApiResponse<CartDto>> removeFromCart(
            @AuthenticationPrincipal User user,
            @PathVariable Long foodItemId
    ) {
        CartDto cart = cartService.removeFromCart(user, foodItemId);
        return ResponseEntity.ok(ApiResponse.success("Товар удален из корзины", cart));
    }

    @DeleteMapping("/clear")
    @Operation(summary = "Очистить корзину")
    public ResponseEntity<ApiResponse<Void>> clearCart(@AuthenticationPrincipal User user) {
        cartService.clearCart(user);
        return ResponseEntity.ok(ApiResponse.success("Корзина очищена", null));
    }
}

