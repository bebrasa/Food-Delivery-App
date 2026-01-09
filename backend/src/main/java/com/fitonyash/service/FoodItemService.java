package com.fitonyash.service;

import com.fitonyash.dto.FoodItemDto;
import com.fitonyash.exception.NotFoundException;
import com.fitonyash.model.Category;
import com.fitonyash.model.FoodItem;
import com.fitonyash.model.MenuType;
import com.fitonyash.model.User;
import com.fitonyash.repository.CategoryRepository;
import com.fitonyash.repository.FavoriteRepository;
import com.fitonyash.repository.FoodItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FoodItemService {

    private final FoodItemRepository foodItemRepository;
    private final CategoryRepository categoryRepository;
    private final FavoriteRepository favoriteRepository;

    @Transactional(readOnly = true)
    public List<FoodItemDto> getAllFoodItems(User user) {
        Set<Long> favoriteIds = user != null ? getFavoriteIds(user.getId()) : Set.of();
        
        return foodItemRepository.findAll().stream()
                .filter(FoodItem::getIsAvailable)
                .map(item -> FoodItemDto.fromEntity(item, favoriteIds.contains(item.getId())))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Page<FoodItemDto> getFoodItemsPaginated(Pageable pageable, User user) {
        Set<Long> favoriteIds = user != null ? getFavoriteIds(user.getId()) : Set.of();
        
        return foodItemRepository.findByIsAvailableTrue(pageable)
                .map(item -> FoodItemDto.fromEntity(item, favoriteIds.contains(item.getId())));
    }

    @Transactional(readOnly = true)
    public FoodItemDto getFoodItemById(Long id, User user) {
        FoodItem foodItem = foodItemRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Блюдо не найдено"));
        
        boolean isFavorite = user != null && favoriteRepository.existsByUserIdAndFoodItemId(user.getId(), id);
        return FoodItemDto.fromEntity(foodItem, isFavorite);
    }

    @Transactional(readOnly = true)
    public List<FoodItemDto> getFoodItemsByCategory(Long categoryId, User user) {
        Set<Long> favoriteIds = user != null ? getFavoriteIds(user.getId()) : Set.of();
        
        return foodItemRepository.findByCategoryIdAndIsAvailableTrue(categoryId).stream()
                .map(item -> FoodItemDto.fromEntity(item, favoriteIds.contains(item.getId())))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<FoodItemDto> getFoodItemsByMenuType(MenuType menuType, User user) {
        Set<Long> favoriteIds = user != null ? getFavoriteIds(user.getId()) : Set.of();
        
        return foodItemRepository.findByMenuTypeAndIsAvailableTrue(menuType).stream()
                .map(item -> FoodItemDto.fromEntity(item, favoriteIds.contains(item.getId())))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<FoodItemDto> getPopularFoodItems(User user) {
        Set<Long> favoriteIds = user != null ? getFavoriteIds(user.getId()) : Set.of();
        
        return foodItemRepository.findByIsPopularTrueAndIsAvailableTrue().stream()
                .map(item -> FoodItemDto.fromEntity(item, favoriteIds.contains(item.getId())))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<FoodItemDto> getNewFoodItems(User user) {
        Set<Long> favoriteIds = user != null ? getFavoriteIds(user.getId()) : Set.of();
        
        return foodItemRepository.findByIsNewTrueAndIsAvailableTrue().stream()
                .map(item -> FoodItemDto.fromEntity(item, favoriteIds.contains(item.getId())))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<FoodItemDto> searchFoodItems(String query, User user) {
        Set<Long> favoriteIds = user != null ? getFavoriteIds(user.getId()) : Set.of();
        
        return foodItemRepository.searchByNameOrDescription(query).stream()
                .map(item -> FoodItemDto.fromEntity(item, favoriteIds.contains(item.getId())))
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<FoodItemDto> getLatestFoodItems(int limit, User user) {
        Set<Long> favoriteIds = user != null ? getFavoriteIds(user.getId()) : Set.of();
        
        return foodItemRepository.findLatestItems(PageRequest.of(0, limit)).stream()
                .map(item -> FoodItemDto.fromEntity(item, favoriteIds.contains(item.getId())))
                .collect(Collectors.toList());
    }

    @Transactional
    public FoodItemDto createFoodItem(FoodItemDto dto) {
        Category category = categoryRepository.findById(dto.getCategoryId())
                .orElseThrow(() -> new NotFoundException("Категория не найдена"));

        FoodItem foodItem = FoodItem.builder()
                .name(dto.getName())
                .description(dto.getDescription())
                .price(dto.getPrice())
                .imageUrl(dto.getImageUrl())
                .calories(dto.getCalories())
                .proteins(dto.getProteins())
                .fats(dto.getFats())
                .carbs(dto.getCarbs())
                .weightGrams(dto.getWeightGrams())
                .cookingTimeMinutes(dto.getCookingTimeMinutes())
                .isPopular(dto.getIsPopular() != null && dto.getIsPopular())
                .isNew(dto.getIsNew() != null && dto.getIsNew())
                .category(category)
                .menuType(dto.getMenuType())
                .build();

        foodItem = foodItemRepository.save(foodItem);
        return FoodItemDto.fromEntity(foodItem);
    }

    @Transactional
    public FoodItemDto updateFoodItem(Long id, FoodItemDto dto) {
        FoodItem foodItem = foodItemRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Блюдо не найдено"));

        if (dto.getName() != null) foodItem.setName(dto.getName());
        if (dto.getDescription() != null) foodItem.setDescription(dto.getDescription());
        if (dto.getPrice() != null) foodItem.setPrice(dto.getPrice());
        if (dto.getImageUrl() != null) foodItem.setImageUrl(dto.getImageUrl());
        if (dto.getCalories() != null) foodItem.setCalories(dto.getCalories());
        if (dto.getProteins() != null) foodItem.setProteins(dto.getProteins());
        if (dto.getFats() != null) foodItem.setFats(dto.getFats());
        if (dto.getCarbs() != null) foodItem.setCarbs(dto.getCarbs());
        if (dto.getWeightGrams() != null) foodItem.setWeightGrams(dto.getWeightGrams());
        if (dto.getCookingTimeMinutes() != null) foodItem.setCookingTimeMinutes(dto.getCookingTimeMinutes());
        if (dto.getIsAvailable() != null) foodItem.setIsAvailable(dto.getIsAvailable());
        if (dto.getIsPopular() != null) foodItem.setIsPopular(dto.getIsPopular());
        if (dto.getIsNew() != null) foodItem.setIsNew(dto.getIsNew());
        if (dto.getMenuType() != null) foodItem.setMenuType(dto.getMenuType());

        if (dto.getCategoryId() != null) {
            Category category = categoryRepository.findById(dto.getCategoryId())
                    .orElseThrow(() -> new NotFoundException("Категория не найдена"));
            foodItem.setCategory(category);
        }

        foodItem = foodItemRepository.save(foodItem);
        return FoodItemDto.fromEntity(foodItem);
    }

    @Transactional
    public void deleteFoodItem(Long id) {
        FoodItem foodItem = foodItemRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Блюдо не найдено"));
        foodItem.setIsAvailable(false);
        foodItemRepository.save(foodItem);
    }

    private Set<Long> getFavoriteIds(Long userId) {
        return favoriteRepository.findByUserIdWithFoodItems(userId).stream()
                .map(fav -> fav.getFoodItem().getId())
                .collect(Collectors.toSet());
    }
}

