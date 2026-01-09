package com.fitonyash.controller;

import com.fitonyash.dto.ApiResponse;
import com.fitonyash.dto.CreateOrderRequest;
import com.fitonyash.dto.OrderDto;
import com.fitonyash.model.OrderStatus;
import com.fitonyash.model.User;
import com.fitonyash.service.OrderService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
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
@RequestMapping("/api/orders")
@RequiredArgsConstructor
@SecurityRequirement(name = "bearerAuth")
@Tag(name = "Заказы", description = "API для работы с заказами")
public class OrderController {

    private final OrderService orderService;

    @PostMapping
    @Operation(summary = "Создать заказ")
    public ResponseEntity<ApiResponse<OrderDto>> createOrder(
            @AuthenticationPrincipal User user,
            @Valid @RequestBody CreateOrderRequest request
    ) {
        OrderDto order = orderService.createOrder(user, request);
        return ResponseEntity.ok(ApiResponse.success("Заказ создан", order));
    }

    @GetMapping
    @Operation(summary = "Получить историю заказов")
    public ResponseEntity<ApiResponse<Page<OrderDto>>> getUserOrders(
            @AuthenticationPrincipal User user,
            @PageableDefault(size = 10) Pageable pageable
    ) {
        Page<OrderDto> orders = orderService.getUserOrders(user, pageable);
        return ResponseEntity.ok(ApiResponse.success(orders));
    }

    @GetMapping("/{id}")
    @Operation(summary = "Получить заказ по ID")
    public ResponseEntity<ApiResponse<OrderDto>> getOrderById(
            @AuthenticationPrincipal User user,
            @PathVariable Long id
    ) {
        OrderDto order = orderService.getOrderById(user, id);
        return ResponseEntity.ok(ApiResponse.success(order));
    }

    @GetMapping("/number/{orderNumber}")
    @Operation(summary = "Получить заказ по номеру")
    public ResponseEntity<ApiResponse<OrderDto>> getOrderByNumber(
            @AuthenticationPrincipal User user,
            @PathVariable String orderNumber
    ) {
        OrderDto order = orderService.getOrderByNumber(user, orderNumber);
        return ResponseEntity.ok(ApiResponse.success(order));
    }

    @PostMapping("/{id}/cancel")
    @Operation(summary = "Отменить заказ")
    public ResponseEntity<ApiResponse<OrderDto>> cancelOrder(
            @AuthenticationPrincipal User user,
            @PathVariable Long id
    ) {
        OrderDto order = orderService.cancelOrder(user, id);
        return ResponseEntity.ok(ApiResponse.success("Заказ отменен", order));
    }

    // Админские endpoints
    @GetMapping("/admin/active")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Получить активные заказы (для админа)")
    public ResponseEntity<ApiResponse<List<OrderDto>>> getActiveOrders() {
        List<OrderDto> orders = orderService.getActiveOrders();
        return ResponseEntity.ok(ApiResponse.success(orders));
    }

    @PutMapping("/admin/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    @Operation(summary = "Обновить статус заказа (для админа)")
    public ResponseEntity<ApiResponse<OrderDto>> updateOrderStatus(
            @PathVariable Long id,
            @RequestParam OrderStatus status
    ) {
        OrderDto order = orderService.updateOrderStatus(id, status);
        return ResponseEntity.ok(ApiResponse.success("Статус заказа обновлен", order));
    }
}

