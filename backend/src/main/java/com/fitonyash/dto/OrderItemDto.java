package com.fitonyash.dto;

import com.fitonyash.model.OrderItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderItemDto {
    
    private Long id;
    private Long foodItemId;
    private String foodItemName;
    private String foodItemImageUrl;
    private Integer quantity;
    private BigDecimal priceAtOrder;
    private BigDecimal subtotal;
    
    public static OrderItemDto fromEntity(OrderItem orderItem) {
        return OrderItemDto.builder()
                .id(orderItem.getId())
                .foodItemId(orderItem.getFoodItem().getId())
                .foodItemName(orderItem.getFoodItemName())
                .foodItemImageUrl(orderItem.getFoodItem().getImageUrl())
                .quantity(orderItem.getQuantity())
                .priceAtOrder(orderItem.getPriceAtOrder())
                .subtotal(orderItem.getPriceAtOrder().multiply(BigDecimal.valueOf(orderItem.getQuantity())))
                .build();
    }
}

