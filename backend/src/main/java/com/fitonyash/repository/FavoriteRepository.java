package com.fitonyash.repository;

import com.fitonyash.model.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    
    @Query("SELECT f FROM Favorite f JOIN FETCH f.foodItem WHERE f.user.id = :userId")
    List<Favorite> findByUserIdWithFoodItems(@Param("userId") Long userId);
    
    Optional<Favorite> findByUserIdAndFoodItemId(Long userId, Long foodItemId);
    
    boolean existsByUserIdAndFoodItemId(Long userId, Long foodItemId);
    
    void deleteByUserIdAndFoodItemId(Long userId, Long foodItemId);
}

