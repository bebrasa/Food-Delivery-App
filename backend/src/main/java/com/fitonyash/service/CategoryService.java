package com.fitonyash.service;

import com.fitonyash.dto.CategoryDto;
import com.fitonyash.exception.NotFoundException;
import com.fitonyash.model.Category;
import com.fitonyash.repository.CategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CategoryService {

    private final CategoryRepository categoryRepository;

    @Transactional(readOnly = true)
    public List<CategoryDto> getAllCategories() {
        return categoryRepository.findByIsActiveTrueOrderByDisplayOrderAsc()
                .stream()
                .map(CategoryDto::fromEntity)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public CategoryDto getCategoryById(Long id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Категория не найдена"));
        return CategoryDto.fromEntity(category);
    }

    @Transactional
    public CategoryDto createCategory(CategoryDto dto) {
        Category category = Category.builder()
                .name(dto.getName())
                .nameEn(dto.getNameEn())
                .description(dto.getDescription())
                .imageUrl(dto.getImageUrl())
                .displayOrder(dto.getDisplayOrder())
                .build();

        category = categoryRepository.save(category);
        return CategoryDto.fromEntity(category);
    }

    @Transactional
    public CategoryDto updateCategory(Long id, CategoryDto dto) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Категория не найдена"));

        if (dto.getName() != null) category.setName(dto.getName());
        if (dto.getNameEn() != null) category.setNameEn(dto.getNameEn());
        if (dto.getDescription() != null) category.setDescription(dto.getDescription());
        if (dto.getImageUrl() != null) category.setImageUrl(dto.getImageUrl());
        if (dto.getDisplayOrder() != null) category.setDisplayOrder(dto.getDisplayOrder());

        category = categoryRepository.save(category);
        return CategoryDto.fromEntity(category);
    }

    @Transactional
    public void deleteCategory(Long id) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Категория не найдена"));
        category.setIsActive(false);
        categoryRepository.save(category);
    }
}

