package com.fitonyash.dto;

import com.fitonyash.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserProfileDto {
    
    private Long id;
    private String email;
    private String fullName;
    private String phoneNumber;
    private String avatarUrl;
    private String deliveryAddress;
    private LocalDateTime createdAt;
    
    public static UserProfileDto fromEntity(User user) {
        return UserProfileDto.builder()
                .id(user.getId())
                .email(user.getEmail())
                .fullName(user.getFullName())
                .phoneNumber(user.getPhoneNumber())
                .avatarUrl(user.getAvatarUrl())
                .deliveryAddress(user.getDeliveryAddress())
                .createdAt(user.getCreatedAt())
                .build();
    }
}

