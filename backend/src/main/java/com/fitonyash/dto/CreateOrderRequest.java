package com.fitonyash.dto;

import com.fitonyash.model.PaymentMethod;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateOrderRequest {
    
    @NotBlank(message = "Адрес доставки обязателен")
    private String deliveryAddress;
    
    private String deliveryNotes;
    
    private String phoneNumber;
    
    private PaymentMethod paymentMethod;
}

