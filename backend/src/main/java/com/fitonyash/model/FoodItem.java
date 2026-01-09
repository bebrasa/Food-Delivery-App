package com.fitonyash.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "food_items")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FoodItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(length = 1000)
    private String description;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal price;

    @Column(name = "image_url")
    private String imageUrl;

    @Column(precision = 5, scale = 1)
    private BigDecimal calories;

    @Column(precision = 5, scale = 1)
    private BigDecimal proteins;

    @Column(precision = 5, scale = 1)
    private BigDecimal fats;

    @Column(precision = 5, scale = 1)
    private BigDecimal carbs;

    @Column(name = "weight_grams")
    private Integer weightGrams;

    @Column(name = "cooking_time_minutes")
    private Integer cookingTimeMinutes;

    @Column(name = "is_available")
    @Builder.Default
    private Boolean isAvailable = true;

    @Column(name = "is_popular")
    @Builder.Default
    private Boolean isPopular = false;

    @Column(name = "is_new")
    @Builder.Default
    private Boolean isNew = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Enumerated(EnumType.STRING)
    @Column(name = "menu_type")
    private MenuType menuType;

    @Column(name = "created_at")
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}

