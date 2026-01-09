package com.fitonyash.config;

import com.fitonyash.model.*;
import com.fitonyash.repository.CategoryRepository;
import com.fitonyash.repository.FoodItemRepository;
import com.fitonyash.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Component
@RequiredArgsConstructor
@Slf4j
@Profile("!test")
public class DataLoader implements CommandLineRunner {

    private final CategoryRepository categoryRepository;
    private final FoodItemRepository foodItemRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public void run(String... args) {
        if (categoryRepository.count() == 0) {
            log.info("Загрузка начальных данных...");
            loadCategories();
            loadFoodItems();
            loadAdminUser();
            log.info("Начальные данные загружены успешно!");
        }
    }

    private void loadCategories() {
        Category breakfast = categoryRepository.save(Category.builder()
                .name("Завтраки")
                .nameEn("breakfast")
                .description("Полезные завтраки и смузи")
                .imageUrl("/images/categories/breakfast.jpg")
                .displayOrder(1)
                .build());

        Category salads = categoryRepository.save(Category.builder()
                .name("Салаты")
                .nameEn("salads")
                .description("Свежие салаты")
                .imageUrl("/images/categories/salads.jpg")
                .displayOrder(2)
                .build());

        Category soups = categoryRepository.save(Category.builder()
                .name("Супы")
                .nameEn("soups")
                .description("Горячие супы")
                .imageUrl("/images/categories/soups.jpg")
                .displayOrder(3)
                .build());

        Category sushi = categoryRepository.save(Category.builder()
                .name("Суши и роллы")
                .nameEn("sushi")
                .description("Японская кухня")
                .imageUrl("/images/categories/sushi.jpg")
                .displayOrder(4)
                .build());

        Category drinks = categoryRepository.save(Category.builder()
                .name("Напитки")
                .nameEn("drinks")
                .description("Напитки и смузи")
                .imageUrl("/images/categories/drinks.jpg")
                .displayOrder(5)
                .build());

        Category desserts = categoryRepository.save(Category.builder()
                .name("Десерты")
                .nameEn("desserts")
                .description("Полезные сладости")
                .imageUrl("/images/categories/desserts.jpg")
                .displayOrder(6)
                .build());

        log.info("Категории загружены: {}", categoryRepository.count());
    }

    private void loadFoodItems() {
        Category breakfast = categoryRepository.findByName("Завтраки").orElseThrow();
        Category salads = categoryRepository.findByName("Салаты").orElseThrow();
        Category sushi = categoryRepository.findByName("Суши и роллы").orElseThrow();
        Category desserts = categoryRepository.findByName("Десерты").orElseThrow();

        // Завтраки
        foodItemRepository.save(FoodItem.builder()
                .name("Овсянка матча-шпинат")
                .description("Полезная овсянка с матча и свежим шпинатом. Богата антиоксидантами и витаминами.")
                .price(new BigDecimal("350"))
                .imageUrl("/images/food/cereal.jpg")
                .calories(new BigDecimal("280"))
                .proteins(new BigDecimal("12"))
                .fats(new BigDecimal("8"))
                .carbs(new BigDecimal("45"))
                .weightGrams(300)
                .cookingTimeMinutes(15)
                .category(breakfast)
                .menuType(MenuType.BREAKFAST)
                .isPopular(true)
                .build());

        foodItemRepository.save(FoodItem.builder()
                .name("Тосты с фермерским яйцом")
                .description("Хрустящие тосты из цельнозернового хлеба с яйцом пашот и авокадо.")
                .price(new BigDecimal("420"))
                .imageUrl("/images/food/egg.jpg")
                .calories(new BigDecimal("380"))
                .proteins(new BigDecimal("18"))
                .fats(new BigDecimal("22"))
                .carbs(new BigDecimal("28"))
                .weightGrams(250)
                .cookingTimeMinutes(12)
                .category(breakfast)
                .menuType(MenuType.BREAKFAST)
                .isPopular(true)
                .isNew(true)
                .build());

        // Салаты
        foodItemRepository.save(FoodItem.builder()
                .name("Салат-мусс с тыквой")
                .description("Нежный салат-мусс с запеченной тыквой, рукколой и кедровыми орешками.")
                .price(new BigDecimal("480"))
                .imageUrl("/images/food/saladPumkin.jpg")
                .calories(new BigDecimal("220"))
                .proteins(new BigDecimal("8"))
                .fats(new BigDecimal("15"))
                .carbs(new BigDecimal("18"))
                .weightGrams(280)
                .cookingTimeMinutes(10)
                .category(salads)
                .menuType(MenuType.SALAD)
                .isPopular(true)
                .build());

        // Суши
        foodItemRepository.save(FoodItem.builder()
                .name("Ролл от шефа")
                .description("Филадельфия с лососем, сливочным сыром и огурцом.")
                .price(new BigDecimal("650"))
                .imageUrl("/images/food/philadelphia.jpg")
                .calories(new BigDecimal("320"))
                .proteins(new BigDecimal("14"))
                .fats(new BigDecimal("18"))
                .carbs(new BigDecimal("35"))
                .weightGrams(250)
                .cookingTimeMinutes(20)
                .category(sushi)
                .menuType(MenuType.SUSHI)
                .isPopular(true)
                .build());

        foodItemRepository.save(FoodItem.builder()
                .name("Ролл от шефа №2")
                .description("Калифорния с крабом, авокадо и икрой тобико.")
                .price(new BigDecimal("580"))
                .imageUrl("/images/food/california.jpg")
                .calories(new BigDecimal("290"))
                .proteins(new BigDecimal("12"))
                .fats(new BigDecimal("14"))
                .carbs(new BigDecimal("38"))
                .weightGrams(240)
                .cookingTimeMinutes(20)
                .category(sushi)
                .menuType(MenuType.SUSHI)
                .isNew(true)
                .build());

        // Десерты
        foodItemRepository.save(FoodItem.builder()
                .name("Ягодный десерт")
                .description("Нежный десерт с бананом и свежими ягодами. Без сахара.")
                .price(new BigDecimal("320"))
                .imageUrl("/images/food/bananaBerry.jpg")
                .calories(new BigDecimal("180"))
                .proteins(new BigDecimal("4"))
                .fats(new BigDecimal("6"))
                .carbs(new BigDecimal("28"))
                .weightGrams(200)
                .cookingTimeMinutes(5)
                .category(desserts)
                .menuType(MenuType.DESSERT)
                .isPopular(true)
                .isNew(true)
                .build());

        foodItemRepository.save(FoodItem.builder()
                .name("Курица в лепёшке")
                .description("Сочная куриная грудка с овощами в цельнозерновой лепёшке.")
                .price(new BigDecimal("390"))
                .imageUrl("/images/food/chickenRoll.jpg")
                .calories(new BigDecimal("420"))
                .proteins(new BigDecimal("32"))
                .fats(new BigDecimal("12"))
                .carbs(new BigDecimal("42"))
                .weightGrams(320)
                .cookingTimeMinutes(15)
                .category(breakfast)
                .menuType(MenuType.MEAT)
                .build());

        log.info("Блюда загружены: {}", foodItemRepository.count());
    }

    private void loadAdminUser() {
        if (!userRepository.existsByEmail("admin@fitonyash.ru")) {
            User admin = User.builder()
                    .email("admin@fitonyash.ru")
                    .password(passwordEncoder.encode("admin123"))
                    .fullName("Администратор")
                    .role(Role.ADMIN)
                    .build();
            userRepository.save(admin);
            log.info("Администратор создан: admin@fitonyash.ru / admin123");
        }
    }
}

