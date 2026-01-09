package com.fitonyash.dto;

import com.fitonyash.model.CartItem;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartItemDto {
    
    private Long id;
    private Long foodItemId;
    private String foodItemName;
    private String foodItemImageUrl;
    private BigDecimal price;
    private Integer quantity;
    private BigDecimal subtotal;
    
    public static CartItemDto fromEntity(CartItem cartItem) {
        return CartItemDto.builder()
                .id(cartItem.getId())
                .foodItemId(cartItem.getFoodItem().getId())
                .foodItemName(cartItem.getFoodItem().getName())
                .foodItemImageUrl(cartItem.getFoodItem().getImageUrl())
                .price(cartItem.getFoodItem().getPrice())
                .quantity(cartItem.getQuantity())
                .subtotal(cartItem.getFoodItem().getPrice().multiply(BigDecimal.valueOf(cartItem.getQuantity())))
                .build();
    }
}

