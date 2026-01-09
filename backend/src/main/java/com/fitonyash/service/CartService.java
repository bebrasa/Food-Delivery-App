package com.fitonyash.service;

import com.fitonyash.dto.CartDto;
import com.fitonyash.exception.BadRequestException;
import com.fitonyash.exception.NotFoundException;
import com.fitonyash.model.Cart;
import com.fitonyash.model.CartItem;
import com.fitonyash.model.FoodItem;
import com.fitonyash.model.User;
import com.fitonyash.repository.CartItemRepository;
import com.fitonyash.repository.CartRepository;
import com.fitonyash.repository.FoodItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final FoodItemRepository foodItemRepository;

    @Transactional(readOnly = true)
    public CartDto getCart(User user) {
        Cart cart = getOrCreateCart(user);
        return CartDto.fromEntity(cart);
    }

    @Transactional
    public CartDto addToCart(User user, Long foodItemId, Integer quantity) {
        if (quantity == null || quantity < 1) {
            quantity = 1;
        }

        FoodItem foodItem = foodItemRepository.findById(foodItemId)
                .orElseThrow(() -> new NotFoundException("Блюдо не найдено"));

        if (!foodItem.getIsAvailable()) {
            throw new BadRequestException("Блюдо временно недоступно");
        }

        Cart cart = getOrCreateCart(user);

        Optional<CartItem> existingItem = cartItemRepository.findByCartIdAndFoodItemId(cart.getId(), foodItemId);

        if (existingItem.isPresent()) {
            CartItem cartItem = existingItem.get();
            cartItem.setQuantity(cartItem.getQuantity() + quantity);
            cartItemRepository.save(cartItem);
        } else {
            CartItem cartItem = CartItem.builder()
                    .cart(cart)
                    .foodItem(foodItem)
                    .quantity(quantity)
                    .build();
            cart.getItems().add(cartItem);
            cartItemRepository.save(cartItem);
        }

        return CartDto.fromEntity(cartRepository.findByUserIdWithItems(user.getId()).orElse(cart));
    }

    @Transactional
    public CartDto updateCartItemQuantity(User user, Long foodItemId, Integer quantity) {
        if (quantity < 0) {
            throw new BadRequestException("Количество не может быть отрицательным");
        }

        Cart cart = cartRepository.findByUserIdWithItems(user.getId())
                .orElseThrow(() -> new NotFoundException("Корзина не найдена"));

        CartItem cartItem = cartItemRepository.findByCartIdAndFoodItemId(cart.getId(), foodItemId)
                .orElseThrow(() -> new NotFoundException("Товар не найден в корзине"));

        if (quantity == 0) {
            cart.getItems().remove(cartItem);
            cartItemRepository.delete(cartItem);
        } else {
            cartItem.setQuantity(quantity);
            cartItemRepository.save(cartItem);
        }

        return CartDto.fromEntity(cartRepository.findByUserIdWithItems(user.getId()).orElse(cart));
    }

    @Transactional
    public CartDto removeFromCart(User user, Long foodItemId) {
        Cart cart = cartRepository.findByUserIdWithItems(user.getId())
                .orElseThrow(() -> new NotFoundException("Корзина не найдена"));

        CartItem cartItem = cartItemRepository.findByCartIdAndFoodItemId(cart.getId(), foodItemId)
                .orElseThrow(() -> new NotFoundException("Товар не найден в корзине"));

        cart.getItems().remove(cartItem);
        cartItemRepository.delete(cartItem);

        return CartDto.fromEntity(cartRepository.findByUserIdWithItems(user.getId()).orElse(cart));
    }

    @Transactional
    public void clearCart(User user) {
        Cart cart = cartRepository.findByUserId(user.getId())
                .orElseThrow(() -> new NotFoundException("Корзина не найдена"));

        cart.getItems().clear();
        cartRepository.save(cart);
    }

    private Cart getOrCreateCart(User user) {
        return cartRepository.findByUserIdWithItems(user.getId())
                .orElseGet(() -> {
                    Cart newCart = Cart.builder()
                            .user(user)
                            .build();
                    return cartRepository.save(newCart);
                });
    }
}

