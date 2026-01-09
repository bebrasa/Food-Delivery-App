package com.fitonyash.service;

import com.fitonyash.dto.CreateOrderRequest;
import com.fitonyash.dto.OrderDto;
import com.fitonyash.exception.BadRequestException;
import com.fitonyash.exception.NotFoundException;
import com.fitonyash.model.*;
import com.fitonyash.repository.CartRepository;
import com.fitonyash.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderRepository orderRepository;
    private final CartRepository cartRepository;
    private final CartService cartService;

    @Transactional
    public OrderDto createOrder(User user, CreateOrderRequest request) {
        Cart cart = cartRepository.findByUserIdWithItems(user.getId())
                .orElseThrow(() -> new NotFoundException("Корзина не найдена"));

        if (cart.getItems().isEmpty()) {
            throw new BadRequestException("Корзина пуста");
        }

        Order order = Order.builder()
                .orderNumber(generateOrderNumber())
                .user(user)
                .deliveryAddress(request.getDeliveryAddress())
                .deliveryNotes(request.getDeliveryNotes())
                .phoneNumber(request.getPhoneNumber() != null ? request.getPhoneNumber() : user.getPhoneNumber())
                .paymentMethod(request.getPaymentMethod() != null ? request.getPaymentMethod() : PaymentMethod.CASH)
                .totalPrice(cart.getTotalPrice())
                .estimatedDeliveryTime(LocalDateTime.now().plusMinutes(45))
                .build();

        List<OrderItem> orderItems = cart.getItems().stream()
                .map(cartItem -> OrderItem.builder()
                        .order(order)
                        .foodItem(cartItem.getFoodItem())
                        .quantity(cartItem.getQuantity())
                        .priceAtOrder(cartItem.getFoodItem().getPrice())
                        .foodItemName(cartItem.getFoodItem().getName())
                        .build())
                .collect(Collectors.toList());

        order.setItems(orderItems);
        Order savedOrder = orderRepository.save(order);

        // Очищаем корзину после создания заказа
        cartService.clearCart(user);

        return OrderDto.fromEntity(savedOrder);
    }

    @Transactional(readOnly = true)
    public Page<OrderDto> getUserOrders(User user, Pageable pageable) {
        return orderRepository.findByUserIdOrderByCreatedAtDesc(user.getId(), pageable)
                .map(OrderDto::fromEntity);
    }

    @Transactional(readOnly = true)
    public OrderDto getOrderById(User user, Long orderId) {
        Order order = orderRepository.findByIdWithItems(orderId)
                .orElseThrow(() -> new NotFoundException("Заказ не найден"));

        if (!order.getUser().getId().equals(user.getId())) {
            throw new NotFoundException("Заказ не найден");
        }

        return OrderDto.fromEntity(order);
    }

    @Transactional(readOnly = true)
    public OrderDto getOrderByNumber(User user, String orderNumber) {
        Order order = orderRepository.findByOrderNumber(orderNumber)
                .orElseThrow(() -> new NotFoundException("Заказ не найден"));

        if (!order.getUser().getId().equals(user.getId())) {
            throw new NotFoundException("Заказ не найден");
        }

        return OrderDto.fromEntity(order);
    }

    @Transactional
    public OrderDto cancelOrder(User user, Long orderId) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new NotFoundException("Заказ не найден"));

        if (!order.getUser().getId().equals(user.getId())) {
            throw new NotFoundException("Заказ не найден");
        }

        if (order.getStatus() != OrderStatus.PENDING && order.getStatus() != OrderStatus.CONFIRMED) {
            throw new BadRequestException("Заказ нельзя отменить на данном этапе");
        }

        order.setStatus(OrderStatus.CANCELLED);
        order = orderRepository.save(order);

        return OrderDto.fromEntity(order);
    }

    // Админские методы
    @Transactional(readOnly = true)
    public List<OrderDto> getActiveOrders() {
        List<OrderStatus> activeStatuses = List.of(
                OrderStatus.PENDING,
                OrderStatus.CONFIRMED,
                OrderStatus.PREPARING,
                OrderStatus.READY,
                OrderStatus.DELIVERING
        );

        return orderRepository.findActiveOrders(activeStatuses).stream()
                .map(OrderDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional
    public OrderDto updateOrderStatus(Long orderId, OrderStatus status) {
        Order order = orderRepository.findById(orderId)
                .orElseThrow(() -> new NotFoundException("Заказ не найден"));

        order.setStatus(status);

        if (status == OrderStatus.DELIVERED) {
            order.setDeliveredAt(LocalDateTime.now());
        }

        order = orderRepository.save(order);
        return OrderDto.fromEntity(order);
    }

    private String generateOrderNumber() {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        String randomPart = UUID.randomUUID().toString().substring(0, 4).toUpperCase();
        return "FN-" + timestamp + "-" + randomPart;
    }
}

