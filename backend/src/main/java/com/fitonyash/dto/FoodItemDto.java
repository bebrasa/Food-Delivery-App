package com.fitonyash.dto;

import com.fitonyash.model.FoodItem;
import com.fitonyash.model.MenuType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FoodItemDto {
    
    private Long id;
    private String name;
    private String description;
    private BigDecimal price;
    private String imageUrl;
    private BigDecimal calories;
    private BigDecimal proteins;
    private BigDecimal fats;
    private BigDecimal carbs;
    private Integer weightGrams;
    private Integer cookingTimeMinutes;
    private Boolean isAvailable;
    private Boolean isPopular;
    private Boolean isNew;
    private Long categoryId;
    private String categoryName;
    private MenuType menuType;
    private Boolean isFavorite;
    
    public static FoodItemDto fromEntity(FoodItem foodItem) {
        return FoodItemDto.builder()
                .id(foodItem.getId())
                .name(foodItem.getName())
                .description(foodItem.getDescription())
                .price(foodItem.getPrice())
                .imageUrl(foodItem.getImageUrl())
                .calories(foodItem.getCalories())
                .proteins(foodItem.getProteins())
                .fats(foodItem.getFats())
                .carbs(foodItem.getCarbs())
                .weightGrams(foodItem.getWeightGrams())
                .cookingTimeMinutes(foodItem.getCookingTimeMinutes())
                .isAvailable(foodItem.getIsAvailable())
                .isPopular(foodItem.getIsPopular())
                .isNew(foodItem.getIsNew())
                .categoryId(foodItem.getCategory().getId())
                .categoryName(foodItem.getCategory().getName())
                .menuType(foodItem.getMenuType())
                .isFavorite(false)
                .build();
    }
    
    public static FoodItemDto fromEntity(FoodItem foodItem, boolean isFavorite) {
        FoodItemDto dto = fromEntity(foodItem);
        dto.setIsFavorite(isFavorite);
        return dto;
    }
}

