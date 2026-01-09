package com.fitonyash.dto;

import com.fitonyash.model.Category;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoryDto {
    
    private Long id;
    private String name;
    private String nameEn;
    private String description;
    private String imageUrl;
    private Integer displayOrder;
    private Integer itemsCount;
    
    public static CategoryDto fromEntity(Category category) {
        return CategoryDto.builder()
                .id(category.getId())
                .name(category.getName())
                .nameEn(category.getNameEn())
                .description(category.getDescription())
                .imageUrl(category.getImageUrl())
                .displayOrder(category.getDisplayOrder())
                .itemsCount(category.getFoodItems() != null ? category.getFoodItems().size() : 0)
                .build();
    }
}

