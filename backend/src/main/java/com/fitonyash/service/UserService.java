package com.fitonyash.service;

import com.fitonyash.dto.UpdateProfileRequest;
import com.fitonyash.dto.UserProfileDto;
import com.fitonyash.exception.NotFoundException;
import com.fitonyash.model.User;
import com.fitonyash.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional(readOnly = true)
    public UserProfileDto getProfile(User user) {
        return UserProfileDto.fromEntity(user);
    }

    @Transactional
    public UserProfileDto updateProfile(User user, UpdateProfileRequest request) {
        if (request.getFullName() != null) {
            user.setFullName(request.getFullName());
        }
        if (request.getPhoneNumber() != null) {
            user.setPhoneNumber(request.getPhoneNumber());
        }
        if (request.getAvatarUrl() != null) {
            user.setAvatarUrl(request.getAvatarUrl());
        }
        if (request.getDeliveryAddress() != null) {
            user.setDeliveryAddress(request.getDeliveryAddress());
        }

        user = userRepository.save(user);
        return UserProfileDto.fromEntity(user);
    }

    @Transactional
    public void changePassword(User user, String oldPassword, String newPassword) {
        if (!passwordEncoder.matches(oldPassword, user.getPassword())) {
            throw new NotFoundException("Неверный текущий пароль");
        }

        user.setPassword(passwordEncoder.encode(newPassword));
        userRepository.save(user);
    }
}

