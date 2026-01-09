package com.fitonyash.dto;

import com.fitonyash.model.Order;
import com.fitonyash.model.OrderStatus;
import com.fitonyash.model.PaymentMethod;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDto {
    
    private Long id;
    private String orderNumber;
    private List<OrderItemDto> items;
    private OrderStatus status;
    private BigDecimal totalPrice;
    private String deliveryAddress;
    private String deliveryNotes;
    private String phoneNumber;
    private PaymentMethod paymentMethod;
    private Boolean isPaid;
    private LocalDateTime createdAt;
    private LocalDateTime estimatedDeliveryTime;
    private LocalDateTime deliveredAt;
    
    public static OrderDto fromEntity(Order order) {
        List<OrderItemDto> items = order.getItems().stream()
                .map(OrderItemDto::fromEntity)
                .collect(Collectors.toList());
        
        return OrderDto.builder()
                .id(order.getId())
                .orderNumber(order.getOrderNumber())
                .items(items)
                .status(order.getStatus())
                .totalPrice(order.getTotalPrice())
                .deliveryAddress(order.getDeliveryAddress())
                .deliveryNotes(order.getDeliveryNotes())
                .phoneNumber(order.getPhoneNumber())
                .paymentMethod(order.getPaymentMethod())
                .isPaid(order.getIsPaid())
                .createdAt(order.getCreatedAt())
                .estimatedDeliveryTime(order.getEstimatedDeliveryTime())
                .deliveredAt(order.getDeliveredAt())
                .build();
    }
}

