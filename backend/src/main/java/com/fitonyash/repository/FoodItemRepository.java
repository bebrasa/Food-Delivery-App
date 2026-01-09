package com.fitonyash.repository;

import com.fitonyash.model.FoodItem;
import com.fitonyash.model.MenuType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FoodItemRepository extends JpaRepository<FoodItem, Long> {
    
    List<FoodItem> findByCategoryIdAndIsAvailableTrue(Long categoryId);
    
    List<FoodItem> findByMenuTypeAndIsAvailableTrue(MenuType menuType);
    
    List<FoodItem> findByIsPopularTrueAndIsAvailableTrue();
    
    List<FoodItem> findByIsNewTrueAndIsAvailableTrue();
    
    @Query("SELECT f FROM FoodItem f WHERE f.isAvailable = true AND " +
           "(LOWER(f.name) LIKE LOWER(CONCAT('%', :query, '%')) OR " +
           "LOWER(f.description) LIKE LOWER(CONCAT('%', :query, '%')))")
    List<FoodItem> searchByNameOrDescription(@Param("query") String query);
    
    Page<FoodItem> findByIsAvailableTrue(Pageable pageable);
    
    @Query("SELECT f FROM FoodItem f WHERE f.isAvailable = true ORDER BY f.createdAt DESC")
    List<FoodItem> findLatestItems(Pageable pageable);
}

