package com.fitonyash.service;

import com.fitonyash.dto.FoodItemDto;
import com.fitonyash.exception.NotFoundException;
import com.fitonyash.model.Favorite;
import com.fitonyash.model.FoodItem;
import com.fitonyash.model.User;
import com.fitonyash.repository.FavoriteRepository;
import com.fitonyash.repository.FoodItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FavoriteService {

    private final FavoriteRepository favoriteRepository;
    private final FoodItemRepository foodItemRepository;

    @Transactional(readOnly = true)
    public List<FoodItemDto> getFavorites(User user) {
        return favoriteRepository.findByUserIdWithFoodItems(user.getId()).stream()
                .map(fav -> FoodItemDto.fromEntity(fav.getFoodItem(), true))
                .collect(Collectors.toList());
    }

    @Transactional
    public FoodItemDto addToFavorites(User user, Long foodItemId) {
        FoodItem foodItem = foodItemRepository.findById(foodItemId)
                .orElseThrow(() -> new NotFoundException("Блюдо не найдено"));

        if (!favoriteRepository.existsByUserIdAndFoodItemId(user.getId(), foodItemId)) {
            Favorite favorite = Favorite.builder()
                    .user(user)
                    .foodItem(foodItem)
                    .build();
            favoriteRepository.save(favorite);
        }

        return FoodItemDto.fromEntity(foodItem, true);
    }

    @Transactional
    public void removeFromFavorites(User user, Long foodItemId) {
        if (!favoriteRepository.existsByUserIdAndFoodItemId(user.getId(), foodItemId)) {
            throw new NotFoundException("Блюдо не найдено в избранном");
        }
        favoriteRepository.deleteByUserIdAndFoodItemId(user.getId(), foodItemId);
    }

    @Transactional
    public FoodItemDto toggleFavorite(User user, Long foodItemId) {
        FoodItem foodItem = foodItemRepository.findById(foodItemId)
                .orElseThrow(() -> new NotFoundException("Блюдо не найдено"));

        boolean isFavorite;
        if (favoriteRepository.existsByUserIdAndFoodItemId(user.getId(), foodItemId)) {
            favoriteRepository.deleteByUserIdAndFoodItemId(user.getId(), foodItemId);
            isFavorite = false;
        } else {
            Favorite favorite = Favorite.builder()
                    .user(user)
                    .foodItem(foodItem)
                    .build();
            favoriteRepository.save(favorite);
            isFavorite = true;
        }

        return FoodItemDto.fromEntity(foodItem, isFavorite);
    }

    @Transactional(readOnly = true)
    public boolean isFavorite(User user, Long foodItemId) {
        return favoriteRepository.existsByUserIdAndFoodItemId(user.getId(), foodItemId);
    }
}

