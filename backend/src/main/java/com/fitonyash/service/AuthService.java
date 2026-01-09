package com.fitonyash.service;

import com.fitonyash.dto.auth.AuthResponse;
import com.fitonyash.dto.auth.LoginRequest;
import com.fitonyash.dto.auth.RefreshTokenRequest;
import com.fitonyash.dto.auth.RegisterRequest;
import com.fitonyash.exception.BadRequestException;
import com.fitonyash.exception.UnauthorizedException;
import com.fitonyash.model.Cart;
import com.fitonyash.model.RefreshToken;
import com.fitonyash.model.User;
import com.fitonyash.repository.CartRepository;
import com.fitonyash.repository.RefreshTokenRepository;
import com.fitonyash.repository.UserRepository;
import com.fitonyash.security.JwtService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final CartRepository cartRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    @Value("${jwt.refresh-token-expiration}")
    private long refreshTokenExpiration;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("Пользователь с таким email уже существует");
        }

        User user = User.builder()
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .fullName(request.getFullName())
                .phoneNumber(request.getPhoneNumber())
                .build();

        user = userRepository.save(user);

        // Создаем пустую корзину для пользователя
        Cart cart = Cart.builder()
                .user(user)
                .build();
        cartRepository.save(cart);

        return generateAuthResponse(user);
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UnauthorizedException("Неверный email или пароль"));

        // Удаляем старые refresh токены
        refreshTokenRepository.deleteByUserId(user.getId());

        return generateAuthResponse(user);
    }

    @Transactional
    public AuthResponse refreshToken(RefreshTokenRequest request) {
        RefreshToken refreshToken = refreshTokenRepository.findByToken(request.getRefreshToken())
                .orElseThrow(() -> new UnauthorizedException("Недействительный refresh token"));

        if (refreshToken.isExpired()) {
            refreshTokenRepository.delete(refreshToken);
            throw new UnauthorizedException("Refresh token истек");
        }

        User user = refreshToken.getUser();

        // Удаляем старый refresh token
        refreshTokenRepository.delete(refreshToken);

        return generateAuthResponse(user);
    }

    @Transactional
    public void logout(Long userId) {
        refreshTokenRepository.deleteByUserId(userId);
    }

    private AuthResponse generateAuthResponse(User user) {
        String accessToken = jwtService.generateToken(user);
        String refreshToken = createRefreshToken(user);

        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(jwtService.getAccessTokenExpiration() / 1000)
                .user(AuthResponse.UserDto.builder()
                        .id(user.getId())
                        .email(user.getEmail())
                        .fullName(user.getFullName())
                        .phoneNumber(user.getPhoneNumber())
                        .avatarUrl(user.getAvatarUrl())
                        .deliveryAddress(user.getDeliveryAddress())
                        .build())
                .build();
    }

    private String createRefreshToken(User user) {
        RefreshToken refreshToken = RefreshToken.builder()
                .user(user)
                .token(UUID.randomUUID().toString())
                .expiryDate(Instant.now().plusMillis(refreshTokenExpiration))
                .build();

        refreshTokenRepository.save(refreshToken);
        return refreshToken.getToken();
    }
}

