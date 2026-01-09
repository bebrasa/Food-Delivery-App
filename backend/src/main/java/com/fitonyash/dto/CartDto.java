package com.fitonyash.dto;

import com.fitonyash.model.Cart;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CartDto {
    
    private Long id;
    private List<CartItemDto> items;
    private BigDecimal totalPrice;
    private Integer totalItems;
    
    public static CartDto fromEntity(Cart cart) {
        List<CartItemDto> items = cart.getItems().stream()
                .map(CartItemDto::fromEntity)
                .collect(Collectors.toList());
        
        return CartDto.builder()
                .id(cart.getId())
                .items(items)
                .totalPrice(cart.getTotalPrice())
                .totalItems(cart.getTotalItems())
                .build();
    }
}

