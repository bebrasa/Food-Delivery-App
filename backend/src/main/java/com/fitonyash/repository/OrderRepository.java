package com.fitonyash.repository;

import com.fitonyash.model.Order;
import com.fitonyash.model.OrderStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    
    @Query("SELECT o FROM Order o LEFT JOIN FETCH o.items oi LEFT JOIN FETCH oi.foodItem WHERE o.id = :id")
    Optional<Order> findByIdWithItems(@Param("id") Long id);
    
    @Query("SELECT o FROM Order o WHERE o.user.id = :userId ORDER BY o.createdAt DESC")
    Page<Order> findByUserIdOrderByCreatedAtDesc(@Param("userId") Long userId, Pageable pageable);
    
    List<Order> findByUserIdAndStatus(Long userId, OrderStatus status);
    
    Optional<Order> findByOrderNumber(String orderNumber);
    
    @Query("SELECT o FROM Order o WHERE o.status IN :statuses ORDER BY o.createdAt ASC")
    List<Order> findActiveOrders(@Param("statuses") List<OrderStatus> statuses);
}

